package com.exemplo;


import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(name = "demo", url = "http://spring-boot-service.demo-namespace.svc.cluster.local")
public interface FeignDemo {

    @GetMapping
    public String mensagem(@RequestParam(value = "mensagem") String mensagem);
}
