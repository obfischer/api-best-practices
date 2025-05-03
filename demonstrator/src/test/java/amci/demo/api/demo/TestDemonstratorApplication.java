package amci.demo.api.demo;

import org.springframework.boot.SpringApplication;

public class TestDemonstratorApplication {

	public static void main(String[] args) {
		SpringApplication.from(DemonstratorApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
