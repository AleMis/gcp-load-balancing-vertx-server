package pl.aleksandermiszkiewicz;

import io.vertx.core.Vertx;
import io.vertx.core.http.HttpClient;
import io.vertx.core.http.HttpClientOptions;
import io.vertx.core.http.HttpClientResponse;
import io.vertx.core.http.HttpMethod;
import io.vertx.ext.unit.Async;
import io.vertx.ext.unit.TestContext;
import io.vertx.ext.unit.junit.VertxUnitRunner;
import lombok.extern.slf4j.Slf4j;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import pl.aleksandermiszkiewicz.confi.ServerConfig;

/**
 * @author aleksander.miszkiewicz
 */
@Slf4j
@RunWith(VertxUnitRunner.class)
public class DefaultHttpServerTest {

	private static final int PORT = 8989;
	private static final String LOCALHOST = "localhost";

	private Vertx vertx;

	private HttpClient client;

	@Before
	public void init() {
		this.vertx = Vertx.vertx();
		ServerConfig serverConfig = new ServerConfig();
		serverConfig.setPort(PORT);
		vertx.deployVerticle(new DefaultHttpServer(vertx, serverConfig));
		this.client = vertx.createHttpClient(new HttpClientOptions()
				.setSsl(false)
				.setDefaultPort(PORT)
				.setDefaultHost(LOCALHOST));
	}

	@Test
	public void shouldStartHttpServerAndResponseWithHostName(TestContext ctx) {
		Async async = ctx.async();

		client.request(HttpMethod.GET, "hello")
				.handler(r -> testResponseHandler(r, ctx, async))
				.end();

		async.awaitSuccess();
	}

	private void testResponseHandler(HttpClientResponse response, TestContext ctx, Async async) {
		response.bodyHandler(r -> {
			log.info("Response {}", r.toString());
			ctx.assertTrue(r.toString().contains("Hello My Friend!"));
			async.complete();
		});
	}
}
