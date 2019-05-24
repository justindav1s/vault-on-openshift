package org.jnd.microservices.vault;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jnd.microservices.vault.model.Person;
import org.jnd.microservices.vault.repository.PersonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Properties;
import java.util.UUID;

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

	@Value("${spring.datasource.username:default}")
	String demouser;
	@Value("${spring.datasource.password:default}")
	String demopassword;

	@Autowired
	PersonRepository personRepository;

	@PostConstruct
	private void postConstruct() {
		log.info("*****************My db.password is: " + dbpassword);
		log.info("*****************My broker.password is: " + brokerpassword);
		log.info("*****************My demouser is: " + demouser);
		log.info("*****************My demopassword is: " + demopassword);

		String uuid = UUID.randomUUID().toString();
		log.info("*****************My UUID is: " + uuid + " length : "+uuid.length());

		Pageable firstPageWithTenElements = PageRequest.of(0, 10);

		Page<Person> persons = personRepository.findAll(firstPageWithTenElements);
		log.info("*****************My persons is: " + persons.toString());

		for (Person p : persons)	{
			log.info("*****************My persons is: " + p.getFirstname());
		}

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

	@RequestMapping(value = "/person/list", method = RequestMethod.GET)
	public Page<Person> listPerson() {
		Pageable firstPageWithTenElements = PageRequest.of(0, 10);

		Page<Person> persons = personRepository.findAll(firstPageWithTenElements);

		return persons;
	}
}
