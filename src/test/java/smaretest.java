import com.intuit.karate.junit5.Karate;

public class smaretest {

    @Karate.Test
    public Karate Run(){
        return Karate.run("SMARE/trusted_entities_registry/ToolDefController/error-cases/tools_list.feature").relativeTo(getClass());
    }
}