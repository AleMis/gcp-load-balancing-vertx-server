package pl.aleksandermiszkiewicz;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Vertx;
import lombok.RequiredArgsConstructor;

import javax.annotation.PostConstruct;
/**
 * @author aleksander.miszkiewicz
 */
@RequiredArgsConstructor
public class VerticleDeployer {

	private final Vertx vertx;

	private final AbstractVerticle verticle;

	@PostConstruct
	public void deploy() {
		vertx.deployVerticle(verticle);
	}
}
