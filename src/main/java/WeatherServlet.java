import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Scanner;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

/**
 * Servlet implementation class WeatherServlet
 */
@WebServlet("/WeatherServlet")
public class WeatherServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public WeatherServlet() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("index.html");
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // API Key
    String apiKey = "51844667b090621ff6d81c7c1ff55263"; // Replace with your actual API key

    // Get the city from the form input
    String city = request.getParameter("city");
    
    if (city == null || city.trim().isEmpty()) {
        request.setAttribute("error", "City name cannot be empty.");
        request.getRequestDispatcher("index.html").forward(request, response);
        return;
    }

    // Encode the city name
    String encodedCity = URLEncoder.encode(city, "UTF-8");

    // Create the URL for the OpenWeatherMap API request
    String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=" + encodedCity + "&appid=" + apiKey;

    try {
        URL url = new URL(apiUrl);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");

        int responseCode = connection.getResponseCode();
        if (responseCode != 200) {
            throw new IOException("Server returned HTTP response code: " + responseCode + " for URL: " + apiUrl);
        }

        InputStream inputStream = connection.getInputStream();
        InputStreamReader reader = new InputStreamReader(inputStream);
        Scanner scanner = new Scanner(reader);
        StringBuilder responseContent = new StringBuilder();

        while (scanner.hasNext()) {
            responseContent.append(scanner.nextLine());
        }

        scanner.close();
        reader.close();

        // Parse the JSON response to extract temperature, date, and humidity
        Gson gson = new Gson();
        JsonObject jsonObject = gson.fromJson(responseContent.toString(), JsonObject.class);

        // Date & Time
        long dateTimestamp = jsonObject.get("dt").getAsLong() * 1000;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String date = sdf.format(new Date(dateTimestamp));

        // Temperature
        double temperatureKelvin = jsonObject.getAsJsonObject("main").get("temp").getAsDouble();
        int temperatureCelsius = (int) (temperatureKelvin - 273.15);

        // Humidity
        int humidity = jsonObject.getAsJsonObject("main").get("humidity").getAsInt();

        // Wind Speed
        double windSpeed = jsonObject.getAsJsonObject("wind").get("speed").getAsDouble();

        // Weather Condition
        String weatherCondition = jsonObject.getAsJsonArray("weather").get(0).getAsJsonObject().get("main").getAsString();
        
        // Set the data as request attributes (for sending to the JSP page)
        request.setAttribute("date", date);
        request.setAttribute("city", city);
        request.setAttribute("temperature", temperatureCelsius);
        request.setAttribute("weatherCondition", weatherCondition);
        request.setAttribute("humidity", humidity);
        request.setAttribute("windSpeed", windSpeed);
        request.setAttribute("weatherData", responseContent.toString());

        connection.disconnect();
        request.getRequestDispatcher("final.jsp").forward(request, response);
    } catch (IOException e) {
        e.printStackTrace();
        request.setAttribute("error", "Failed to retrieve weather data. Please try again.");
    }
}
}
