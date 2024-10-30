public  class QueryCommerceOrders {
    
    static final Integer COUNT_CONST = 200;   
    
    public void executeHttp()
    {
        /*        
if(Test.isRunningTest()){
return;
}
*/
        httpCall();
    }
    @Future(callout=true)
    public static void httpCall()
    {
        String accessToken = CommerceCloudToken.getToken();
        
        if(accessToken == null && String.isBlank(accessToken)) 
        { 
            throw new NotAuthenticatedException('Error in retrieving CC token');
        }
        integer start = 0;
        Integer total = 0;
        DateTime mostRecentOrder; /* Max last modified date of the orders */
        
        Map<String,Commerce_order__c> orderMap = new Map<String, Commerce_order__c>();
        do{     
            System.debug('start=' + start);            
            
            RequestWrapper reqWrapper = new RequestWrapper(COUNT_CONST, start, 'lastModified');
            String reqBody = JSON.serialize(reqWrapper);
            reqBody = reqBody.replace('select1','select');
            reqBody = reqBody.replace('from1','from');
            reqBody = reqBody.replace('query1','query');
            system.debug('reqBody--->' + reqBody); 
            
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            
            req.setMethod('POST');
            req.setEndpoint('callout:Commerce_Cloud_BM' + '/s/merlenorman/dw/shop/v21_3/order_search');
            req.setHeader('Authorization','Bearer '+accessToken);
            req.setHeader('Content-Type','application/json');
            req.setBody(reqBody);
            req.setTimeout(120000);
            System.debug('req===='+req);
            Http http = new Http();
            res = http.send(req);
            
            if(res.getStatusCode() == 200){
                system.debug('Response Body ==> '+res.getBody());
                system.debug('Request Body ==> '+req.getBody());
                Map<String,Object> jsonParsed =(Map<String,Object> ) JSON.deserializeUntyped(res.getBody());
                List<object> hits = (List<object>)jsonParsed.get('hits');
                system.debug('hits==> '+hits);
                total = (Integer)jsonParsed.get('total');
                System.debug('total=' + total);
                if (total == 0)
                {
                    //                HandleNextRunStartTime.setNextSearhFrom(); 
                    return;
                }
                for (object hit : hits)
                {
                    Map<String,Object> tmp = (Map<String,Object>) hit;
                    Map<String,Object> data = (Map<String,Object>)tmp.get('data');
                    List<object> shipments = (List<object>) data.get('shipments');
                    List<object> productItems = (List<object>) data.get('product_items');
                    //            system.debug(productItems);
                    String orderNo = (String) data.get('order_no');
                    
                    Integer intVal = Integer.ValueOf( orderNo );
                    orderNo = String.valueOf(intVal);
                    
                    Map<String,Object> customerInfo = (Map<String,Object>)data.get('customer_info');
                    Map<String,Object> billingAddress = (Map<String,Object>)data.get('billing_address');
                    Double orderTotal= (Double)data.get('order_total');
                    String status = (String) data.get('status'); 
                    System.debug('status=== '+status);
                    
                    if(status.equalsIgnoreCase('Created') ||  status.equalsIgnoreCase('Failed')){
                    	continue;
                    }
                    
                    String cMNOrderStatus = (String) data.get('c_mnOrderStatus');
                    System.debug('cMNOrderStatus=== '+cMNOrderStatus);
                    String confirmationStatus = (String) data.get('confirmation_status');
                    System.debug('confirmationStatus=== '+confirmationStatus);
                    String creationDateStr = (String) data.get('creation_date');
                    creationDateStr=creationDateStr.replace('.000Z','');
                    DateTime creationDate = DateTime.valueOfGMT(creationDateStr.replace('T', ' '));
                    
                    String mostRecentOrderStr = (String) data.get('last_modified');
                    mostRecentOrderStr=mostRecentOrderStr.replace('.000Z','');
                    mostRecentOrder= DateTime.valueOfGMT(mostRecentOrderStr.replace('T', ' '));
                    
                    
                    String createdBy = (String) data.get('created_by');
                    String exportStatus = (String) data.get('export_status');
                    String c_storeID = (String) data.get('c_storeID');
                    
                    String address1 = (String) billingAddress.get('address1');         
                    String address2 = (String) billingAddress.get('address2');          
                    String city = (String) billingAddress.get('city');          
                    String postalCode = (String) billingAddress.get('postal_code');
                    String stateCode = (String) billingAddress.get('state_code');
                    String countryCode = (String) billingAddress.get('country_code');
                    Double shippingTotal = (Double)data.get('shipping_total');                
                    
                    
                    String products = '';          
                    for (object productItem : productItems)
                    {
                        tmp = (Map<String,Object>) productItem;
                        products = products + (String)tmp.get('product_name') + '\n';
                        
                    }
                    
                    String customerName = (String) customerInfo.get('customer_name');
                    String[] names= customerName.split(' ',2);
                    String email = (String) customerInfo.get('email');
                    String customerNo = (String) customerInfo.get('customer_no');
                    
                    Commerce_order__c order = new  Commerce_order__c();
                    order.address1__c = address1;
                    order.address2__c =address2;
                    order.city__c =city;
                    order.confirmation_status__c =confirmationStatus;
                    order.country_code__c =countryCode;
                    order.created_by__c =createdBy;
                    order.creation_date__c =creationDate;
                    order.customer_no__c =customerNo;
                    order.email__c =email;
                    order.export_status__c =exportStatus;
                    order.MNOrder_status__c =cMNOrderStatus;
                    order.order_total__c =orderTotal;
                    order.Name =orderNo;
                    order.postal_code__c =postalCode;
                    order.Preferred_Studio_Id__c =c_storeID;
                    order.product_name__c =products;
                    order.shipping_total__c =shippingTotal;
                    order.state_code__c =stateCode;
                    order.status__c =status;
                    order.order_no__c =orderNo;
                    
                    orderMap.put(orderNo,order); 
                } 
                
                start +=COUNT_CONST;
                System.debug(' start +=COUNT_CONST;=== '+ start);
                System.debug('(start - COUNT_CONST) + COUNT_CONST== '+((start - COUNT_CONST) + COUNT_CONST));
            }else{
                system.debug('Response Status Code : '+res.getStatusCode());
                system.debug('Response body : '+res.getBody());
            }
        } while ((start - COUNT_CONST) + COUNT_CONST < total);
        
        System.debug('---> LIst is ready');
        System.debug('--->mostRecentOrder :'  +mostRecentOrder);
        List<Commerce_order__c> recordsToUpsert = orderMap.values();
        
        
        if(!recordsToUpsert.isEmpty())
            System.enqueueJob(new UpsertCommerceOrders(recordsToUpsert, mostRecentOrder));
    }
    
    public class RequestWrapper
    {
        public List<Sorts> sorts;
        
        public Integer count;
        public Integer start;
        public String select1;
        public Query query;
        
        RequestWrapper(Integer count,Integer start,String field)
        {
            this.count = count;
            this.start = start;
            select1='(**)';
            this.query = new Query(field);
            this.sorts = new List<Sorts>();
            Sorts s1 = new Sorts('lastModified','asc');
            this.sorts.add(s1);
            
            
        }
    }
    public class Query
    {
        public FilteredQuery filtered_query;
        Query(String field)
        {
            this.filtered_query = new FilteredQuery(field);
        }
    }
    
    public class FilteredQuery
    {
        public Filter filter;
        public InnerQuery query1;
        FilteredQuery (String field)
        {
            this.filter = new Filter(field);
            this.query1 = new InnerQuery();
        }
        
    }
    
    public class Filter
    {
        public RangeFilter range_filter;
        Filter (String field)
        {
            this.range_filter = new RangeFilter(field);
        }
    }
    
    public class RangeFilter 
    {
        public String field;
        DateTime from1;
        DateTime to;
        RangeFilter (String field)
        {
            this.field = field;
            this.from1 = HandleNextRunStartTime.getSearchFrom();
            
            this.to = datetime.now();
        }
        
    }        
    
    public class Sorts
    {
        String field;
        String sort_order;
        
        Sorts (String field, String sort_order)
        {
            this.field = field;
            this.sort_order=sort_order;
        }
        
    }
    
    public class InnerQuery
    {
        MatchAllQuery match_all_query;
        InnerQuery()
        {
            match_all_query = new MatchAllQuery();
        }
    }
    public class MatchAllQuery
    {
        MatchAllQuery()
        {
            
        }
    }
    
    public class NotAuthenticatedException extends Exception 
    {
        
    }    
    
}