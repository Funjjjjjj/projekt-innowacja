public class SalesforceOAuthClient {
	
    public void callMedicalFacilities() {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint('callout:Agentforce_OAuth/services/apexrest/MedicalFacilities');
        request.setMethod('GET');
        
        try {
            HttpResponse response = http.send(request);
            String jsonString = response.getBody();
			List<Object> records = (List<Object>) JSON.deserializeUntyped(jsonString);
            for (Object obj : records) {
                Map<String, Object> record = (Map<String, Object>) obj;
                String name = (String) record.get('Name');
                String phone = (String) record.get('Phone');
                String email = (String) record.get('Email');
                
                Map<String, Object> address = (Map<String, Object>) record.get('Address');
                String street = (String) address.get('Street');
                String city = (String) address.get('City');
                String postalCode = (String) address.get('PostalCode');
                
                Map<String, Object> openingHours = (Map<String, Object>) record.get('OpeningHours');
    			String monday_hours = (String) openingHours.get('Poniedziałek');
                Time[] monday_time = stringToTime(monday_hours);
                
                String tuesday_hours = (String) openingHours.get('Wtorek');
                Time[] tuesday_time = stringToTime(tuesday_hours);
                
                String wednesday_hours = (String) openingHours.get('Środa');
                Time[] wednesday_time = stringToTime(wednesday_hours);
                
                String thursday_hours = (String) openingHours.get('Czwartek');
                Time[] thursday_time = stringToTime(thursday_hours);
                
                String friday_hours = (String) openingHours.get('Piątek');
                Time[] friday_time = stringToTime(friday_hours);
                
                String saturday_hours = (String) openingHours.get('Sobota');
                Time[] saturday_time = stringToTime(saturday_hours);
                
                String sunday_hours = (String) openingHours.get('Niedziela');
                Time[] sunday_time = stringToTime(sunday_hours);
            
                Facility_Hours__c hours = new Facility_Hours__c();
                hours.Monday_Open__c = monday_time[0];
                hours.Monday_Close__c = monday_time[1];
                
                hours.Tuesday_Open__c = tuesday_time[0];
                hours.Tuesday_Close__c = tuesday_time[1];
                
                hours.Wednesday_Open__c = wednesday_time[0];
                hours.Wednesday_Close__c = wednesday_time[1];
                
                hours.Thursday_Open__c = thursday_time[0];
                hours.Thursday_Close__c = thursday_time[1];
                
                hours.Friday_Open__c = friday_time[0];
                hours.Friday_Close__c = friday_time[1];
                
                hours.Saturday_Open__c = Saturday_time[0];
                hours.Saturday_Close__c = Saturday_time[1];
                
                hours.Sunday_Open__c = sunday_time[0];
                hours.Sunday_Close__c = sunday_time[1];
                hours.name = 'elo';
                
                insert hours;
                
                List<Medical_Facility__c> medical_Facilitys = [SELECT Id,Facility_Hours__c FROM Medical_Facility__c WHERE Name = :name LIMIT 1];
                if (medical_Facilitys.isEmpty()){
                    Medical_Facility__c medical_Facility = new Medical_Facility__c();
                    medical_facility.Type__c = 'Hospital';
                    medical_Facility.email__c = email;
                    medical_Facility.Name = name;
                    medical_Facility.Phone__c = phone;
                    medical_Facility.Facility_Hours__c = hours.id;
                    medical_Facility.put('Facility_Address__Street__s', street);
                    medical_Facility.put('Facility_Address__City__s', city);
                    medical_Facility.put('Facility_Address__PostalCode__s', postalCode);
                    insert medical_Facility;
                }
                else{
                    Medical_Facility__c medical_Facility = medical_Facilitys[0];
                    List<Facility_Hours__c> old_hours = [SELECT Id FROM Facility_Hours__c WHERE Id = :medical_Facility.Facility_Hours__c LIMIT 1];
                    if (!old_hours.isEmpty()){
                    	delete old_hours;
                    }
                    medical_Facility.Facility_Hours__c = hours.id;
                }
                
                
            }
        } catch (Exception e) {
            System.debug('Wyjątek HTTP: ' + e.getMessage());
        }
    }
    
    private Time[] stringToTime(String input){
        String[] hours = input.split(' - ');
        String[] open = hours[0].split(':');
        String[] closed = hours[1].split(':');
        Time[] output = new Time[2];
        output[0] = Time.newInstance(Integer.valueOf(open[0]),Integer.valueOf(open[1]),0,0);
        output[1] = Time.newInstance(Integer.valueOf(closed[0]),Integer.valueOf(closed[1]),0,0); 
    	return output;
    }
}