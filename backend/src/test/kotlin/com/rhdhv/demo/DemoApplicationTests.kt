package com.rhdhv.demo

import com.rhdhv.demo.controller.DemoController
import org.junit.jupiter.api.Test
import org.springframework.boot.test.context.SpringBootTest
import io.restassured.module.mockmvc.RestAssuredMockMvc.*
import org.hamcrest.Matchers.*

@SpringBootTest
class DemoApplicationTests {

	@Test
	fun contextLoads() {
	}

	@Test
	fun givenTheresNoNewClientsRegistered_WhenListingClients_Then2ClientsAreReturned() {
		given().standaloneSetup(DemoController())
		.`when`().get("/clients")
		.then()
				.statusCode(200)
				.body("size()", `is`(2))
	}

}
