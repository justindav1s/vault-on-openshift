package org.jnd.microservices.vault;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Properties;

@SpringBootApplication
@RestController
public class VaultDemoClientApplication {

	private Log log = LogFactory.getLog(VaultDemoClientApplication.class);

	public static void main(String[] args) {
		SpringApplication.run(VaultDemoClientApplication.class, args);
	}

	@Value("${db.password}")
	String dbpassword;
	@Value("${broker.password}")
	String brokerpassword;

	@PostConstruct
	private void postConstruct() {
		log.info("*****************My db.password is: " + dbpassword);
		log.info("*****************My broker.password is: " + brokerpassword);

		Properties myProps = new Properties();
		myProps.putIfAbsent("password", dbpassword);
		try {
			myProps.store(new FileWriter(new File("/tmp/app.properties")), null);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/health", method = RequestMethod.GET)
	public String health() {
		return "OK";
	}

	@RequestMapping(value = "/secret", method = RequestMethod.GET)
	public String getSecret() {
		return dbpassword+", "+brokerpassword;
	}
}
