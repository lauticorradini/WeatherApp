public class WeatherController {
	
    @AuraEnabled(cacheable=true)
    public static Weather__c fetchWeather(String city){
        String APIKey = 'HERE YOUR API KEY';
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
            for(Object weather2 : weatherList){
                Map<String,Object> info = (Map<String,Object>)weather2;
                weather.Name = (String)info.get('main');
                weather.WeatherDescription__c = (String)info.get('description');
                String iconUrl = 'https://openweathermap.org/img/wn/'+ (String)info.get('icon') + '.png';
                weather.Icon__c = iconUrl;
            }


            weather.City__c = (String)results.get('name');
        } else {
            throw new CalloutException('Error ' + response.getBody());
        }
        
        System.debug('Weather: ' + weather.Name);
        System.debug('City: '+ weather.City__c);
        System.debug('Icon: ' + weather.Icon__c);
        return weather;
    }
}