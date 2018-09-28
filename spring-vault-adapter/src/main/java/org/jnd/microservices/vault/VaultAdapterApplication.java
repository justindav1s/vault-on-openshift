package org.jnd.microservices.vault;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Properties;

@SpringBootApplication
public class VaultAdapterApplication implements CommandLineRunner {

	private Log log = LogFactory.getLog(VaultAdapterApplication.class);

	public static void main(String[] args) {
		SpringApplication.run(VaultAdapterApplication.class, args);
	}

	@Value("${password}")
	String password;

	@Value("${APP_NAME}")
	String application;

	@PostConstruct
	private void postConstruct() {
		log.info("*****************My password is: " + password);
	}

	@Override
	public void run(String[] args) throws Exception {

		Properties myProps = new Properties();
		myProps.putIfAbsent("password", password);
		try {
			myProps.store(new FileWriter(new File("/tmp/"+application+".properties")), null);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
