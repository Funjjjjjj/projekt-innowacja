public class DoctorWorkSchedulesUpdate {
    
    public void callDoctorWorkSchedules() {

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint('callout:Agentforce_OAuth/services/apexrest/DoctorWorkSchedules');
        request.setMethod('GET');
        
        try {
            HttpResponse response = http.send(request);
            String jsonString = response.getBody();
			List<Object> records = (List<Object>) JSON.deserializeUntyped(jsonString);
            for (Object obj : records) {
                Map<String, Object> record = (Map<String, Object>) obj;
            	String firstName = (String) record.get('firstName');
                String lastName = (String) record.get('lastName');
                String doctorId = (String) record.get('doctorId');
                String pesel = (String) record.get('pesel');
                Map<String, Object> schedule = (Map<String, Object>) record.get('Schedule');
                Facility_hours__c hours = new Facility_hours__c();
                hours.name = 'elo_elo';
                for (String day : schedule.keySet()) {
                    if (day =='Monday'){
                        Map<String, Object> timeRange = (Map<String, Object>) schedule.get(day);
                        String startTime = (String) timeRange.get('StartTime');
                        String endTime = (String) timeRange.get('EndTime');
                        hours.Monday_Open__c = parseTime(startTime);
                        hours.Monday_Close__c = parseTime(endTime);
                    }
                    else if(day =='Tuesday'){
                        Map<String, Object> timeRange = (Map<String, Object>) schedule.get(day);
                        String startTime = (String) timeRange.get('StartTime');
                        String endTime = (String) timeRange.get('EndTime');
                        hours.Tuesday_Open__c = parseTime(startTime);
                        hours.Tuesday_Close__c = parseTime(endTime);
                    }
                    else if(day =='Wednesday'){
                        Map<String, Object> timeRange = (Map<String, Object>) schedule.get(day);
                        String startTime = (String) timeRange.get('StartTime');
                        String endTime = (String) timeRange.get('EndTime');
                        hours.Wednesday_Open__c = parseTime(startTime);
                        hours.Wednesday_Close__c = parseTime(endTime);
                    }
                    else if(day =='Thursday'){
                        Map<String, Object> timeRange = (Map<String, Object>) schedule.get(day);
                        String startTime = (String) timeRange.get('StartTime');
                        String endTime = (String) timeRange.get('EndTime');
                        hours.Thursday_Open__c = parseTime(startTime);
                        hours.Thursday_Close__c = parseTime(endTime);
                    }
                    else if(day =='Friday'){
                        Map<String, Object> timeRange = (Map<String, Object>) schedule.get(day);
                        String startTime = (String) timeRange.get('StartTime');
                        String endTime = (String) timeRange.get('EndTime');
                        hours.Friday_Open__c = parseTime(startTime);
                        hours.Friday_Close__c = parseTime(endTime);
                    }
                    else if(day =='Saturday'){
                        Map<String, Object> timeRange = (Map<String, Object>) schedule.get(day);
                        String startTime = (String) timeRange.get('StartTime');
                        String endTime = (String) timeRange.get('EndTime');
                        hours.Saturday_Open__c = parseTime(startTime);
                        hours.Saturday_Close__c = parseTime(endTime);
                    }
                    else if(day =='Sunday'){
                        Map<String, Object> timeRange = (Map<String, Object>) schedule.get(day);
                        String startTime = (String) timeRange.get('StartTime');
                        String endTime = (String) timeRange.get('EndTime');
                        hours.Sunday_Open__c = parseTime(startTime);
                        hours.Sunday_Close__c = parseTime(endTime);
                    }
              	}
                insert hours;
                List<Person__c> persons = [SELECT Id, Doctor_Work_Schedules__c FROM Person__c WHERE Personal_ID_Number__c = :pesel LIMIT 1];
                if (persons.isEmpty()) {
    				Person__c person = new Person__c();
                    person.First_Name__c = firstName;
                    person.Name = lastName;
                    person.Personal_ID_Number__c = pesel;
                    person.Doctor_Work_Schedules__c = hours.Id;
                    person.Email__c = 'example@email.con';
                    insert person;
                }
                else{
                    Person__c person = persons[0];
                    List<Facility_Hours__c> old_hours = [SELECT Id FROM Facility_Hours__c WHERE Id = :person.Doctor_Work_Schedules__c LIMIT 1];
                    if (!old_hours.isEmpty()){
                    	delete old_hours;
                    }
                    person.Doctor_Work_Schedules__c = hours.Id;
                }
            }
            
        } catch (Exception e) {
            System.debug('Wyjątek HTTP: ' + e.getMessage());
        }
    }
    
    public static Time parseTime(String hhmm) {
        List<String> parts = hhmm.split(':');
        Integer h = Integer.valueOf(parts[0]);
        Integer m = Integer.valueOf(parts[1]);
        return Time.newInstance(h, m, 0, 0);
    }
}