package org.jnd.microservices.springapp;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Properties;

@SpringBootApplication
public class SpringAppApplication {

	private Log log = LogFactory.getLog(SpringAppApplication.class);

	public static void main(String[] args) {

		SpringApplication.run(SpringAppApplication.class, args);
	}

	String password;

	@Value("${VAULT_USERROLE}")
	String application;

	@PostConstruct
	private void postConstruct() {
		log.info("*****************loading properties from  " + "/tmp/"+application+".properties");

		Properties myProps = new Properties();

		try {
			myProps.load(new FileReader(new File("/tmp/"+application+".properties")));
		} catch (IOException e) {
			e.printStackTrace();
		}

		password = myProps.getProperty("password");
		log.info("*****************My password is: " + password);
	}

	@RequestMapping(value = "/health", method = RequestMethod.GET)
	public String health() {
		return "OK";
	}

	@RequestMapping(value = "/secret", method = RequestMethod.GET)
	public String getSecret() {
		return password;
	}

}
