package pl.aleksandermiszkiewicz.confi;
import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * @author aleksander.miszkiewicz
 */
@Getter
@Setter
@ConfigurationProperties(prefix = "server")
public class ServerConfig {

	private int port;
}
