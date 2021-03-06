package com.rhdhv.demo.controller

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@CrossOrigin
@RestController
class DemoController {

    private val clientList = mutableListOf(ClientDto(1, "John"), ClientDto(2, "Mary"))

    @GetMapping("/clients")
    fun getAll(): ResponseEntity<List<ClientDto>> {
        return ResponseEntity.ok(clientList)
    }

    @GetMapping("/clients/{id}")
    fun getClient(@PathVariable id: Int): List<ClientDto> {
        return clientList.filter { it.id == id }
                .ifEmpty { throw ClientNotFound(id) }
    }

    @PostMapping("/clients")
    fun storeClient(@RequestBody client: CreateClientDto?): ResponseEntity<ClientDto> {
        if (client == null)
            return ResponseEntity.notFound()
                    .build()

        val newClient = ClientDto(clientList.size + 1, client.name)
        clientList.add(newClient);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(newClient);
    }

    @PostMapping("/clients/delete")
    fun deleteClient(@RequestBody client: CreateClientDto?): List<ClientDto> {
        val i = 0;
        /* Going through index's list */
        for (i in clientList.indices) {
            /* Making sure I got an index client list */
            if (client != null) {
                /* If client received as parameter is
                * equal to client[i] index */
                if (clientList[i].name == client.name) {
                    /* Remove that client */
                    clientList.remove(clientList[i]);
                    /* Involve break to avoid ask for non-existing client at the next iteration */
                    break;
                }
            }
        }
        return clientList;
    }

}

data class ClientDto(
        val id: Int,
        val name: String
)

data class CreateClientDto(
        val name: String
)

@ResponseStatus(HttpStatus.NOT_FOUND)
class ClientNotFound(id: Int): Exception("Client with id $id was not found!")
