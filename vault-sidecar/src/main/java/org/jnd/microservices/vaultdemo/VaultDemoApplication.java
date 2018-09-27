package org.jnd.microservices.vaultdemo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.PostConstruct;

@SpringBootApplication
@RestController
public class VaultDemoApplication {

	private Log log = LogFactory.getLog(VaultDemoApplication.class);

	public static void main(String[] args) {
		SpringApplication.run(VaultDemoApplication.class, args);
	}

	@Value("${password}")
	String password;

	@PostConstruct
	private void postConstruct() {
		log.info("*****************My password is: " + password);
	}

	@RequestMapping(value = "/health", method = RequestMethod.GET)
	public String ping() {
		return "OK";
	}
}
