package com.exemplo;


import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;

@Service
@RequiredArgsConstructor
public class FeignDemoImpl {

    private final FeignDemo feigndemo;

    public String mensagem(String mensagem){
        return feigndemo.mensagem(mensagem);
    }
}
