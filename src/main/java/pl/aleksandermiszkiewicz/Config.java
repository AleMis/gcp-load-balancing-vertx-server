package pl.aleksandermiszkiewicz;

import io.vertx.core.Vertx;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import pl.aleksandermiszkiewicz.confi.ServerConfig;

@Configuration
@EnableConfigurationProperties(ServerConfig.class)
public class Config {

	@Bean
	public Vertx vertx() {
		return Vertx.vertx();
	}

	@Bean
	public VerticleDeployer verticleDeployer(Vertx vertx, ServerConfig serverConfig) {
		return new VerticleDeployer(vertx, new DefaultHttpServer(vertx, serverConfig));
	}
}
