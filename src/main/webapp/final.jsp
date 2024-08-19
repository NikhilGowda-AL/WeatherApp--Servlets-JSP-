<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Weather App</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #ff9a9e, #fad0c4, #fad0c4, #fbc2eb, #a18cd1, #fad0c4, #fbc2eb, #ff9a9e);
            background-size: 400% 400%;
            animation: gradientBG 15s ease infinite;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .weather-container {
            background: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 400px;
            text-align: center;
            animation: fadeIn 2s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .weather-search-form {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }

        .weather-search-input {
            padding: 10px;
            border: none;
            border-radius: 5px;
            outline: none;
            flex: 1;
            font-size: 1rem;
            margin-right: 10px;
            transition: box-shadow 0.3s ease;
        }

        .weather-search-input:focus {
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
        }

        .weather-search-button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .weather-search-button:hover {
            background-color: #45a049;
        }

        .weather-icon {
            margin-bottom: 20px;
        }

        .weather-icon img {
            max-width: 100px;
            margin-bottom: 10px;
        }

        .weather-details h2 {
            font-size: 2rem;
            color: #333;
            margin-bottom: 10px;
        }

        .weather-city-details strong {
            font-size: 1.5rem;
            color: #555;
        }

        .weather-date {
            font-size: 1rem;
            color: #777;
            margin-bottom: 20px;
        }

        .weather-stats {
            display: flex;
            justify-content: space-around;
        }

        .weather-humidity, .weather-wind-speed {
            display: flex;
            align-items: center;
        }

        .weather-humidity img, .weather-wind-speed img {
            max-width: 30px;
            margin-right: 10px;
        }

        .weather-humidity span, .weather-wind-speed span {
            font-size: 1rem;
            color: #555;
            margin-right: 5px;
        }

        .weather-humidity h2, .weather-wind-speed h2 {
            font-size: 1.2rem;
            color: #333;
        }
    </style>
</head>

<body>
    <div class="weather-container">
        <div class="weather-search">
            <form action="WeatherServlet" method="post" class="weather-search-form">
                <input type="text" placeholder="Enter City Name" id="searchInput" value=${city} name="city" class="weather-search-input"/>
                <button id="searchButton" class="weather-search-button"><i class="fa-solid fa-magnifying-glass"></i></button>
            </form>
        </div>
        <div class="weather-details">
            <div class="weather-icon">
                <img src="" alt="Clouds" id="weather-icon">
                <h2>${temperature} °C</h2>
                <input type="hidden" id="wc" value="${weatherCondition}">
            </div>
            <div class="weather-city-details">
                <strong>${city}</strong>
                <div class="weather-date">${date}</div>
            </div>
            <div class="weather-stats">
                <div class="weather-humidity">
                    <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhgr7XehXJkOPXbZr8xL42sZEFYlS-1fQcvUMsS2HrrV8pcj3GDFaYmYmeb3vXfMrjGXpViEDVfvLcqI7pJ03pKb_9ldQm-Cj9SlGW2Op8rxArgIhlD6oSLGQQKH9IqH1urPpQ4EAMCs3KOwbzLu57FDKv01PioBJBdR6pqlaxZTJr3HwxOUlFhC9EFyw/s320/thermometer.png" alt="Humidity">
                    <div class="weather-humidity-value">
                        <span>Humidity</span>
                        <h2>${humidity}%</h2>
                    </div>
                </div>
                <div class="weather-wind-speed">
                    <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiyaIguDPkbBMnUDQkGp3wLRj_kvd_GIQ4RHQar7a32mUGtwg3wHLIe0ejKqryX8dnJu-gqU6CBnDo47O7BlzCMCwRbB7u0Pj0CbtGwtyhd8Y8cgEMaSuZKrw5-62etXwo7UoY509umLmndsRmEqqO0FKocqTqjzHvJFC2AEEYjUax9tc1JMWxIWAQR4g/s320/wind.png" alt="Wind Speed">
                    <div class="weather-wind-speed-value">
                        <span>Wind Speed</span>
                        <h2>${windSpeed} km/h</h2>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        var weatherIcon = document.getElementById("weather-icon");
        var val = document.getElementById("wc").value;

        switch (val) {
            case 'Clouds':
                weatherIcon.src = "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiwFTkt5z_dxU6w1UnS1PxiZV3HDiPGsAW5Lrsp09MnlCmkQre9GzO8MnGytaaY1eZoqBN6SMJ4U578_uDtiuXswovr1T3o-Kt5KK0mlN_zC0RDodJFaKHQ3Uk-HIZ3vuMvAKNJi8DDFwWA7F6BOxz78Oh-UePwJTuc3PG0ZIZypPE1xlMPl5z46joaEw/s320/Clouds.png";
                break;
            case 'Clear':
                weatherIcon.src = "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj7pmzNCftryAfpa1YBSzVeYtjgxDQnw09Ug0HVV47J8GEtHPYTH9hJgZ2M1k0YgE0pcZ1qekr4C14zyPCiVuQAfXLClK8Ww3hYB6v77yElP7Lo5BnUKo4n-w6yB17FAbw51WST6YKS0GMwyA4fYNxOZxEyNL6HhUfFRgVhOW0GyRdBRriMHFQ-qfh4cA/s320/sun.png";
                break;
            case 'Rain':
                weatherIcon.src = "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgDW_NdwvxV796rkFf43qmUDiTQePn5dg7PDfn1SijfpjtB0AWJMBcifU6LWyW7iOtjZhfqIJnKEGQ1PwbbXS7NoKMSAmvy7i2ljWXMYLue3EBIBBR2qTFbs6QCe5eoFr2CU9WzCVJ8u0J3z3eAo3Ajv1LXamZASFtbj9sA_gD-Kp3hfgAk17Xh17RoLQ/s320/rainy.png";
                break;
            case 'Mist':
                weatherIcon.src = "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVpL23l0t1U_ibWi01TFcHMF6J_t-9Ada5PavGlwG4M_mKIcx0pV1md9SN9ip1d84NaVowml5Do16XO3nsuttnM2-Ov05d-wCjEYjdzaOYfKvijw8k6Hfj9pOiPyEZTp2W20EPbTeONTgJE2Rdxs4KZUfg6f2PmbMF1094NcqJ7DwSFUQwYiRmVCNvuA/s320/mist.png";
                break;
            case 'Snow':
                weatherIcon.src = "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj-P3iT_uQK95qFY4h7QGdEtbRc1aVQo9BZy0ZWyPBvCNrP-4wnRStw0xYj9e4xa4ZlYISeNZqVJ33UP4YukR4jBennDD_obIN4QxYNZHdzG_z6_MNL2U08wMXwdFhtfvitW5LGiHgrwMJFC8QJFqbSO3woGSBqOdagGxaEQ20_S31Gc-GYL4vYzPzaPw/s320/snow.png";
                break;
            case 'Haze':
                weatherIcon.src = "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjld66Ia5g_hpBn3Impi3zzOBHqWkjQInGLxTb2uXksuCsrkQU8HjlVyLobEJEGg8fRSIxeFzldGEHUmWcaiZBwAcRy4dGDpFX1BjTSB56qmBjW5tEW3RSC9_mCuLU_a8RuXchxGY7Oc8HLLl-IfaDW19Z0ZJJfNae9tECXRIyEu7rmJ3da08z8cI-phw/s320/haze.png";
                break;
        }
    </script>
</body>

</html>
