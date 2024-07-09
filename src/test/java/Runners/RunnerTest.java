package Runners;

import com.intuit.karate.junit5.Karate;

class RunnerTest {

    @Karate.Test
    Karate testSystemProperty() {
        return Karate.run("classpath:Karate/Features/ReqresTest.feature")
                .tags("@ReqResAll")
                .karateEnv("cert");
    }

}