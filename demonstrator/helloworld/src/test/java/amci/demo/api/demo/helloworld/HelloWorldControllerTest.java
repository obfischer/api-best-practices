package amci.demo.api.demo.helloworld;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.reactive.server.WebTestClient;

@SpringBootTest(classes = TestDummyApplication.class, webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class HelloWorldControllerTest {

    @Autowired
    private WebTestClient webTestClient;

    @Test
    void shouldReturnHelloWorld() {
        webTestClient.get().uri("/hello")
                .exchange()
                .expectStatus().isOk()
                .expectBody(String.class).isEqualTo("Hello world");
    }
}
