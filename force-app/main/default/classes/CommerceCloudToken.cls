public class CommerceCloudToken 
{
    
    public Static String getToken()
    {
        String payLoad = 'grant_type=client_credentials' ;
        String token;        
        String url = 'callout:Commerce_Cloud_Token' + '/access_token';
        
        //String url = 'callout:Commerce_Cloud_Token' + '/access_token?client_id=4224b690-d067-414c-b207-97cf16ca74e3';
      	//String authorization = EncodingUtil.base64Encode(Blob.valueof('4224b690-d067-414c-b207-97cf16ca74e3:TestSuccess123!'));
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('POST');
        req.setEndpoint(url);
        //req.setHeader('Authorization','Basic '+ authorization);
        req.setTimeout(120000);
        
        System.debug(url);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');  
        req.setBody(payLoad);
        
        Http http = new Http();
        res = http.send(req);
        System.debug(res.getStatusCode());
        if (res.getStatusCode() == 200)
        {
            Integer expiresIn;
            System.JSONParser parser = System.JSON.createParser(res.getBody());
            while (parser.nextToken() != System.JSONToken.END_OBJECT) 
            {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
                {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
                    {
                        if (text == 'access_token') {
                            token = parser.getText();
                        }else if(text == 'expires_in'){
                            expiresIn = parser.getIntegerValue();
                        }  
                    }
                }	
            }
            system.debug('--->New Token <' + token + '>');
        }
        return token;
        
        
    }
    
}