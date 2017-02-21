import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.support.ui.SystemClock;

import java.util.List;

public class GoogleSuggest {
    public static void main(String[] args) throws Exception {

        System.setProperty("webdriver.chrome.driver", "/sbin/chromedriver");

        ChromeOptions options = new ChromeOptions();
        options.addArguments("no-sandbox");
        options.addArguments("user-data-dir=/srv/data");
        DesiredCapabilities capabilities = DesiredCapabilities.chrome();
        capabilities.setCapability(ChromeOptions.CAPABILITY, options);
        WebDriver driver = new ChromeDriver(capabilities);

        System.out.println("Waiting for Chrome to start...");
        Thread.sleep(5000);

        System.out.println("Open google home page...");
        driver.get("https://www.google.ch");

        // Yes, this is supid ... but it is just an example
        Thread.sleep(5000);

        System.out.println("Open swisscom home page...");
        driver.get("https://www.swisscom.com");

        // Yes, this is supid ... but it is just an example
        Thread.sleep(5000);

        System.out.println("Open post home page...");
        driver.get("https://www.post.ch");
     }
}

