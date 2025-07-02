package com.arzom.store.loggenerator;

import org.springframework.boot.autoconfigure.cassandra.CassandraProperties;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.Timer;

@RestController
public class logGen{
    private final Counter requestCounter;
    private final Timer responseTimer;

    public logGen(MeterRegistry registry) {
        this.requestCounter = registry.counter("custom_requests_total");
        this.responseTimer = registry.timer("custom_response_timer");
    }

    @GetMapping("hello")
    public String log(){
        return "Hello World";
    }

    @PostMapping("/data")
    public String data(RequestBody data){
        ResponseEntity<String> response = new ResponseEntity<String>(data.toString(), HttpStatus.OK);
        System.out.println(response.getBody());
        return response.toString();
    }

    @GetMapping("/")
    public String index(){
        requestCounter.increment();
        return responseTimer.record(()-> {
            return "its Working " + java.time.LocalDateTime.now().toString();
        });
    }
}