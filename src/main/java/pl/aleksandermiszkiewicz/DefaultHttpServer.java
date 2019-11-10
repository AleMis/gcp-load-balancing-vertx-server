package pl.aleksandermiszkiewicz;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.AsyncResult;
import io.vertx.core.Future;
import io.vertx.core.Vertx;
import io.vertx.core.http.HttpServer;
import io.vertx.core.http.HttpServerOptions;
import io.vertx.core.http.HttpServerRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import pl.aleksandermiszkiewicz.confi.ServerConfig;

import java.net.InetAddress;
import java.net.UnknownHostException;

import static java.lang.String.format;
import static java.util.Optional.ofNullable;

/**
 * @author aleksander.miszkiewicz
 */
@Slf4j
@RequiredArgsConstructor
public class DefaultHttpServer extends AbstractVerticle {

	private final Vertx vertx;

	private final ServerConfig serverConfig;

	private HttpServer httpServer;

	private String hostName;

	@Override
	public void start() throws Exception {
		log.info("Server started");
		httpServer = vertx.createHttpServer(new HttpServerOptions()
				.setLogActivity(true))
				.requestHandler(this::handleRequest)
				.listen(serverConfig.getPort(), this::listenHandler);

		this.hostName = getHostName();
		log.info("Host name {}", hostName);
		super.start();
	}

	@Override
	public void stop(Future<Void> stopFuture) throws Exception {
		ofNullable(httpServer).ifPresent(HttpServer::close);
		super.stop(stopFuture);
	}

	private void handleRequest(HttpServerRequest request) {
		request.response().end(format("Hello My Friend! This is response from host %s", this.hostName));
	}

	private void listenHandler(AsyncResult<HttpServer> serverResult) {
		if (serverResult.succeeded()) {
			log.info("Server listen on port {}", this.serverConfig.getPort());
		} else {
			log.error("Server failed to listen on port {}", this.serverConfig.getPort());
		}
	}

	private String getHostName() {
		try {
			return InetAddress.getLocalHost().getHostName();
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		return "";
	}
}
