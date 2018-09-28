package org.jnd.microservices.vault;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.core.env.*;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.*;

@SpringBootApplication
public class VaultAdapterApplication implements CommandLineRunner {

	private Log log = LogFactory.getLog(VaultAdapterApplication.class);

	@Autowired
	private ApplicationContext appContext;

	public static void main(String[] args) {
		SpringApplication.run(VaultAdapterApplication.class, args);
	}

	@Value("${password}")
	String password;

	@Autowired Environment env;

	@Value("${VAULT_USERROLE:test1}")
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
