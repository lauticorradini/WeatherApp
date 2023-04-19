public class WeatherController {
	
    @AuraEnabled(cacheable=true)
    public static List<Weather__c> fetchWeather(String city){
        List<Weather__c> newList = new List<Weather__c>();
        String APIKey = 'YOUR API KEY HERE';
        String endpoint = 'https://api.openweathermap.org/data/2.5/weather?q=' + city + '&units=metric&appid=' + APIKey;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        Weather__c weather = new Weather__c();

        if(response.getStatusCode() == 200){

            Map<String,Object> results = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
            List<Object> weatherList = (List<Object>)results.get('weather');
            weather.City__c = (String)results.get('name');
            for(Object weather2 : weatherList){
                Map<String,Object> info = (Map<String,Object>)weather2;
                weather.Name = (String)info.get('main');
                weather.WeatherDescription__c = (String)info.get('description');
                String iconUrl = 'https://openweathermap.org/img/wn/'+ (String)info.get('icon') + '.png';
                weather.Icon__c = iconUrl;
            }

            Map<String,Object> main = (Map<String,Object>)results.get('main');
            weather.Temperature__c = (Decimal)main.get('temp');
            weather.Humidity__c = (Integer)main.get('humidity');

            Map<String,Object> wind = (Map<String,Object>)results.get('wind');
            weather.Wind__c = (Decimal)wind.get('speed');

            Map<String,Object> sys = (Map<String,Object>)results.get('sys');
            weather.Country__c = (String)sys.get('country');

            //TODO coord, timezone, temp min and temp max, feels like 

        } else {
            throw new CalloutException('Error ' + response.getBody());
        }
        
        //Just for debugging
        System.debug('City: '+ weather.City__c);
        System.debug('Country: ' + weather.Country__c);
        System.debug('Weather: ' + weather.Name);
        System.debug('Temperature: ' + weather.Temperature__c + '°C');
        System.debug('Weather Description: ' + weather.WeatherDescription__c);
        System.debug('Humidity: ' + weather.Humidity__c + '%');
        System.debug('Wind Speed: ' + weather.Wind__c);
        System.debug('Icon: ' + weather.Icon__c);
        newList.add(weather); 
        return newList;
    }
}