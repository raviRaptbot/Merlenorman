@isTest
global class MockCalloutTestClass implements HttpCalloutMock {
    
    String status;
    global MockCalloutTestClass(String status){
        this.status = status;
    }
    
    global HTTPResponse respond(HTTPRequest request){
        HttpResponse response = new HttpResponse();
        
        //accessToken
        if (request.getEndpoint().contains('/access_token')){
            if(this.status == 'Success'){
                String body = '{"access_token": "eyJ0eXAiOiJKV1QiLCJraWQiOiJEMWhPUDdEODN4TjBqZWlqaTI3WWFv","scope": "mail","token_type": "Bearer","expires_in": 1799}';   
                response.setHeader('Content-Type','application/json');
                response.setBody(body);
                response.setStatusCode(200);
                return response;
            }
            
        }
        else if (request.getEndpoint().contains('/order_search'))
        {
            if(this.status == 'Success'){
                String body = 
                    '{'+
                    '    "_v": "21.3",'+
                    '    "_type": "order_search_result",' +
                    '    "count": 2,' +
                    '    "hits": [' +
                    '        {' +
                    '            "_type": "order_search_hit",' +
                    '            "data": {' +
                    '                "_type": "order",' +
                    '                "adjusted_merchandize_total_tax": 10.31,' +
                    '                "adjusted_shipping_total_tax": 0.83,' +
                    '                "billing_address": {' +
                    '                    "_type": "order_address",' +
                    '                    "address1": "Entrada Dr",' +
                    '                    "city": "Los Alamos",' +
                    '                    "country_code": "US",' +
                    '                    "first_name": "Pragati",' +
                    '                    "full_name": "Pragati DK",' +
                    '                    "id": "9328a4180c1489e393538b562b",' +
                    '                    "last_name": "DK",' +
                    '                    "phone": "9567894532",' +
                    '                    "postal_code": "87544",' +
                    '                    "state_code": "NJ"' +
                    '                },' +
                    '                "confirmation_status": "confirmed",' +
                    '                "created_by": "Customer",' +
                    '                "creation_date": "2021-12-21T07:28:40.000Z",' +
                    '                "currency": "USD",' +
                    '                "customer_info": {' +
                    '                    "_type": "customer_info",' +
                    '                    "customer_id": "aboIfh653GZ2F2hX0sBa1tSgdY",' +
                    '                    "customer_name": "Pragati DK",' +
                    '                    "email": "suhas.s@revsolutionsinc.com"' +
                    '                },' +
                    '                "customer_name": "Pragati DK",' +
                    '                "export_status": "exported",' +
                    '                "last_modified": "2021-12-21T07:39:01.000Z",' +
                    '                "merchandize_total_tax": 10.31,' +
                    '                "notes": {' +
                    '                    "_type": "simple_link",' +
                    '                    "link": "https://dev.merlenorman.com/s/merlenorman/dw/shop/v21_3/orders/00011423/notes"' +
                    '                },' +
                    '                "order_no": "00011423",' +
                    '                "order_token": "lN3KZGsU5VbD5MOrAE-HsZGUuITYzENyBWVOTlFcXUw",' +
                    '                "order_total": 146.14,' +
                    '                "payment_instruments": [' +
                    '                    {' +
                    '                        "_type": "order_payment_instrument",' +
                    '                        "amount": 146.14,' +
                    '                        "payment_instrument_id": "24c6ca1e7802079fabd6e3862c",' +
                    '                        "payment_method_id": "PayPal",' +
                    '                        "c_paypalAck": "Success",' +
                    '                        "c_paypalBillingAgreement": false,' +
                    '                        "c_paypalCorrelationId": "f408aec1ba7f8",' +
                    '                        "c_paypalPayerID": "A7B56VBATH6EU",' +
                    '                        "c_paypalPaymentStatus": "Completed",' +
                    '                        "c_paypalToken": "EC-3RG90721PE433631C"' +
                    '                    }' +
                    '                ],' +
                    '                "payment_status": "paid",' +
                    '                "product_items": [' +
                    '                    {' +
                    '                        "_type": "product_item",' +
                    '                        "adjusted_tax": 3.05,' +
                    '                        "base_price": 37.00,' +
                    '                        "bonus_product_line_item": false,' +
                    '                        "gift": false,' +
                    '                        "item_id": "0e6171fabac7d1265512166d98",' +
                    '                        "item_text": "Aqua Bliss",' +
                    '                        "price": 37.00,' +
                    '                        "price_after_item_discount": 37.00,' +
                    '                        "price_after_order_discount": 37.00,' +
                    '                        "product_id": "05092",' +
                    '                        "product_name": "Aqua Bliss",' +
                    '                        "quantity": 1,' +
                    '                        "shipment_id": "me",' +
                    '                        "tax": 3.05,' +
                    '                        "tax_basis": 37.00,' +
                    '                        "tax_class_id": null,' +
                    '                        "tax_rate": 0.082432' +
                    '                    },' +
                    '                    {' +
                    '                        "_type": "product_item",' +
                    '                        "adjusted_tax": 2.81,' +
                    '                        "base_price": 34.00,' +
                    '                        "bonus_product_line_item": false,' +
                    '                        "gift": false,' +
                    '                        "item_id": "7af135e97408689c007f4eee0c",' +
                    '                        "item_text": "Makeup Artistry Face #1 Brush (Foundation)",' +
                    '                        "price": 34.00,' +
                    '                        "price_after_item_discount": 34.00,' +
                    '                        "price_after_order_discount": 34.00,' +
                    '                        "product_id": "59460",' +
                    '                        "product_name": "Makeup Artistry Face #1 Brush (Foundation)",' +
                    '                        "quantity": 1,' +
                    '                        "shipment_id": "me",' +
                    '                        "tax": 2.81,' +
                    '                        "tax_basis": 34.00,' +
                    '                        "tax_class_id": null,' +
                    '                        "tax_rate": 0.082647' +
                    '                    },' +
                    '                    {' +
                    '                        "_type": "product_item",' +
                    '                        "adjusted_tax": 4.45,' +
                    '                        "base_price": 54.00,' +
                    '                        "bonus_product_line_item": false,' +
                    '                        "gift": false,' +
                    '                        "item_id": "aa24348c9f051c7bce0ca9a917",' +
                    '                        "item_text": "Makeup Artistry Face #7 Brush (Angled Foundation)",' +
                    '                        "price": 54.00,' +
                    '                        "price_after_item_discount": 54.00,' +
                    '                        "price_after_order_discount": 54.00,' +
                    '                        "product_id": "59474",' +
                    '                        "product_name": "Makeup Artistry Face #7 Brush (Angled Foundation)",' +
                    '                        "quantity": 1,' +
                    '                        "shipment_id": "me",' +
                    '                        "tax": 4.45,' +
                    '                        "tax_basis": 54.00,' +
                    '                        "tax_class_id": null,' +
                    '                        "tax_rate": 0.082407' +
                    '                    }' +
                    '                ],' +
                    '                "product_sub_total": 125.00,' +
                    '                "product_total": 125.00,' +
                    '                "shipments": [' +
                    '                    {' +
                    '                        "_type": "shipment",' +
                    '                        "adjusted_merchandize_total_tax": 10.31,' +
                    '                        "adjusted_shipping_total_tax": 0.83,' +
                    '                        "gift": false,' +
                    '                        "merchandize_total_tax": 10.31,' +
                    '                        "product_sub_total": 125.00,' +
                    '                        "product_total": 125.00,' +
                    '                        "shipment_id": "me",' +
                    '                        "shipment_no": "00059021",' +
                    '                        "shipment_total": 146.14,' +
                    '                        "shipping_address": {' +
                    '                            "_type": "order_address",' +
                    '                            "address1": "900 Texas",' +
                    '                            "city": "La Feria",' +
                    '                            "country_code": "US",' +
                    '                            "first_name": "Dine",' +
                    '                            "full_name": "Dine MN",' +
                    '                            "id": "a139c1de3db2fa768dd01bdf10",' +
                    '                            "last_name": "MN",' +
                    '                            "phone": "9567894532",' +
                    '                            "postal_code": "78559-5166",' +
                    '                            "state_code": "TX"' +
                    '                        },' +
                    '                        "shipping_status": "not_shipped",' +
                    '                        "shipping_total": 10.00,' +
                    '                        "shipping_total_tax": 0.83,' +
                    '                        "tax_total": 11.14' +
                    '                    }' +
                    '                ],' +
                    '                "shipping_items": [' +
                    '                    {' +
                    '                        "_type": "shipping_item",' +
                    '                        "adjusted_tax": 0.83,' +
                    '                        "base_price": 10.00,' +
                    '                        "item_id": "c73af398b28bc6c7b89f1ebcd0",' +
                    '                        "item_text": "Shipping",' +
                    '                        "price": 10.00,' +
                    '                        "price_after_item_discount": 10.00,' +
                    '                        "shipment_id": "me",' +
                    '                        "tax": 0.83,' +
                    '                        "tax_basis": 10.00,' +
                    '                        "tax_class_id": "Standard",' +
                    '                        "tax_rate": 0.083' +
                    '                    }' +
                    '                ],' +
                    '                "shipping_status": "not_shipped",' +
                    '                "shipping_total": 10.00,' +
                    '                "shipping_total_tax": 0.83,' +
                    '                "site_id": "merlenorman",' +
                    '                "status": "new",' +
                    '                "taxation": "net",' +
                    '                "tax_total": 11.14,' +
                    '                "c_autoAssignedStore": true,' +
                    '                "c_paypalPaymentMethod": "express"' +
                    '            },' +
                    '            "relevance": 0.0' +
                    '        },' +
                    '        {' +
                    '            "_type": "order_search_hit",' +
                    '            "data": {' +
                    '                "_type": "order",' +
                    '                "adjusted_merchandize_total_tax": 4.54,' +
                    '                "adjusted_shipping_total_tax": 2.32,' +
                    '                "billing_address": {' +
                    '                    "_type": "order_address",' +
                    '                    "address1": "367 WOODSTOCK AVE",' +
                    '                    "city": "GLEN ELLYN",' +
                    '                    "country_code": "US",' +
                    '                    "first_name": "Pro",' +
                    '                    "full_name": "Pro Trst",' +
                    '                    "id": "e4ac420064f3b43c0d7f0b57ca",' +
                    '                    "last_name": "Trst",' +
                    '                    "phone": "9123456789",' +
                    '                    "postal_code": "60137-4863",' +
                    '                    "state_code": "IL"' +
                    '                },' +
                    '                "confirmation_status": "confirmed",' +
                    '                "created_by": "Customer",' +
                    '                "creation_date": "2021-12-28T07:26:02.000Z",' +
                    '                "currency": "USD",' +
                    '                "customer_info": {' +
                    '                    "_type": "customer_info",' +
                    '                    "customer_id": "abw9lzzWSrjUhCaTpbznUzRLho",' +
                    '                    "customer_name": "Priya Test",' +
                    '                    "customer_no": "00030501",' +
                    '                    "email": "pkuberappa@liveareacx.com"' +
                    '                },' +
                    '                "customer_name": "Priya Test",' +
                    '                "export_status": "exported",' +
                    '                "last_modified": "2021-12-28T07:39:01.000Z",' +
                    '                "merchandize_total_tax": 4.54,' +
                    '                "notes": {' +
                    '                    "_type": "simple_link",' +
                    '                    "link": "https://dev.merlenorman.com/s/merlenorman/dw/shop/v21_3/orders/00011610/notes"' +
                    '                },' +
                    '                "order_no": "00011610",' +
                    '                "order_token": "cR28yW8N8d6HCdSUFpU4WX_q1qXq8_r_gtZ45bhoqRc",' +
                    '                "order_total": 90.01,' +
                    '                "payment_instruments": [' +
                    '                    {' +
                    '                        "_type": "order_payment_instrument",' +
                    '                        "amount": 90.01,' +
                    '                        "payment_instrument_id": "c46331c3cf83fa19b8e15bd8ff",' +
                    '                        "payment_method_id": "PayPal",' +
                    '                        "c_paypalAck": "Success",' +
                    '                        "c_paypalBillingAgreement": false,' +
                    '                        "c_paypalCorrelationId": "ed6e64c6e73a9",' +
                    '                        "c_paypalPayerID": "PSJ9Y8654FGU4",' +
                    '                        "c_paypalPaymentStatus": "Completed",' +
                    '                        "c_paypalToken": "EC-2B626865RB596623E"' +
                    '                    }' +
                    '                ],' +
                    '                "payment_status": "paid",' +
                    '                "product_items": [' +
                    '                    {' +
                    '                        "_type": "product_item",' +
                    '                        "adjusted_tax": 3.22,' +
                    '                        "base_price": 39.00,' +
                    '                        "bonus_product_line_item": false,' +
                    '                        "gift": false,' +
                    '                        "item_id": "0a5329d65ada0ea95764a21873",' +
                    '                        "item_text": "Treasure Chest Shadow Palette",' +
                    '                        "price": 39.00,' +
                    '                        "price_after_item_discount": 39.00,' +
                    '                        "price_after_order_discount": 39.00,' +
                    '                        "product_id": "14166",' +
                    '                        "product_name": "Treasure Chest Shadow Palette",' +
                    '                        "quantity": 1,' +
                    '                        "shipment_id": "me",' +
                    '                        "tax": 3.22,' +
                    '                        "tax_basis": 39.00,' +
                    '                        "tax_class_id": null,' +
                    '                        "tax_rate": 0.082564' +
                    '                    },' +
                    '                    {' +
                    '                        "_type": "product_item",' +
                    '                        "adjusted_tax": 0.66,' +
                    '                        "base_price": 8.00,' +
                    '                        "bonus_product_line_item": false,' +
                    '                        "gift": false,' +
                    '                        "item_id": "ad9319245c91e3bfbc4375516f",' +
                    '                        "item_text": "Chubby Lip Crayon Aruba",' +
                    '                        "price": 8.00,' +
                    '                        "price_after_item_discount": 8.00,' +
                    '                        "price_after_order_discount": 8.00,' +
                    '                        "product_id": "17221",' +
                    '                        "product_name": "Chubby Lip Crayon Aruba",' +
                    '                        "quantity": 1,' +
                    '                        "shipment_id": "me",' +
                    '                        "tax": 0.66,' +
                    '                        "tax_basis": 8.00,' +
                    '                        "tax_class_id": null,' +
                    '                        "tax_rate": 0.0825' +
                    '                    },' +
                    '                    {' +
                    '                        "_type": "product_item",' +
                    '                        "adjusted_tax": 0.66,' +
                    '                        "base_price": 8.00,' +
                    '                        "bonus_product_line_item": false,' +
                    '                        "gift": false,' +
                    '                        "item_id": "4df35b40cbad7ad2c6e55215e5",' +
                    '                        "item_text": "Chubby Lip Crayon Ladybug",' +
                    '                        "price": 8.00,' +
                    '                        "price_after_item_discount": 8.00,' +
                    '                        "price_after_order_discount": 8.00,' +
                    '                        "product_id": "17220",' +
                    '                        "product_name": "Chubby Lip Crayon Ladybug",' +
                    '                        "quantity": 1,' +
                    '                        "shipment_id": "me",' +
                    '                        "tax": 0.66,' +
                    '                        "tax_basis": 8.00,' +
                    '                        "tax_class_id": null,' +
                    '                        "tax_rate": 0.0825' +
                    '                    }' +
                    '                ],' +
                    '                "product_sub_total": 55.00,' +
                    '                "product_total": 55.00,' +
                    '                "shipments": [' +
                    '                    {' +
                    '                        "_type": "shipment",' +
                    '                        "adjusted_merchandize_total_tax": 4.54,' +
                    '                        "adjusted_shipping_total_tax": 2.32,' +
                    '                        "gift": false,' +
                    '                        "merchandize_total_tax": 4.54,' +
                    '                        "product_sub_total": 55.00,' +
                    '                        "product_total": 55.00,' +
                    '                        "shipment_id": "me",' +
                    '                        "shipment_no": "00060509",' +
                    '                        "shipment_total": 90.01,' +
                    '                        "shipping_address": {' +
                    '                            "_type": "order_address",' +
                    '                            "address1": "367 WOODSTOCK AVE",' +
                    '                            "city": "GLEN ELLYN",' +
                    '                            "country_code": "US",' +
                    '                            "first_name": "Pro",' +
                    '                            "full_name": "Pro Trst",' +
                    '                            "id": "5f50106433ab973b4a54d4256e",' +
                    '                            "last_name": "Trst",' +
                    '                            "phone": "9123456789",' +
                    '                            "postal_code": "60137-4863",' +
                    '                            "state_code": "IL"' +
                    '                        },' +
                    '                        "shipping_method": {' +
                    '                            "_type": "shipping_method",' +
                    '                            "description": "No flammables, only 48 States",' +
                    '                            "id": "FEDEX_STANDARD_OVERNIGHT",' +
                    '                            "name": "FedEx Express",' +
                    '                            "price": 35.00,' +
                    '                            "c_erpShipMethodID": "FEDEX_STANDARD_OVERNIGHT",' +
                    '                            "c_estimatedArrivalTime": "1-2 Days",' +
                    '                            "c_fedexServiceCode": "STANDARD_OVERNIGHT",' +
                    '                            "c_narvarCarrrierCode": "fedex",' +
                    '                            "c_narvarServiceCode": "E1",' +
                    '                            "c_storePickupEnabled": false,' +
                    '                            "c_useFlatRate": false' +
                    '                        },' +
                    '                        "shipping_status": "not_shipped",' +
                    '                        "shipping_total": 28.15,' +
                    '                        "shipping_total_tax": 2.32,' +
                    '                        "tax_total": 6.86' +
                    '                    }' +
                    '                ],' +
                    '                "shipping_items": [' +
                    '                    {' +
                    '                        "_type": "shipping_item",' +
                    '                        "adjusted_tax": 2.32,' +
                    '                        "base_price": 28.15,' +
                    '                        "item_id": "8b905dde9cc22b7b3c472c5e45",' +
                    '                        "item_text": "Shipping",' +
                    '                        "price": 28.15,' +
                    '                        "price_after_item_discount": 28.15,' +
                    '                        "shipment_id": "me",' +
                    '                        "tax": 2.32,' +
                    '                        "tax_basis": 28.15,' +
                    '                        "tax_class_id": null,' +
                    '                        "tax_rate": 0.082416' +
                    '                    }' +
                    '                ],' +
                    '                "shipping_status": "not_shipped",' +
                    '                "shipping_total": 28.15,' +
                    '                "shipping_total_tax": 2.32,' +
                    '                "site_id": "merlenorman",' +
                    '                "status": "new",' +
                    '                "taxation": "net",' +
                    '                "tax_total": 6.86,' +
                    '                "c_paypalPaymentMethod": "express",' +
                    '                "c_storeID": "700176"' +
                    '            },' +
                    '            "relevance": 0.0' +
                    '        }' +
                    '    ],' +
                    '    "next": {' +
                    '        "_type": "result_page",' +
                    '        "count": 2,' +
                    '        "start": 2' +
                    '    },' +
                    '    "query": {' +
                    '        "filtered_query": {' +
                    '            "_type": "filtered_query",' +
                    '            "filter": {' +
                    '                "range_filter": {' +
                    '                    "_type": "range_filter",' +
                    '                    "field": "lastModified",' +
                    '                    "from": "2020-03-08T00:00:00.000Z",' +
                    '                    "to": "2024-03-10T00:00:00.000Z"' +
                    '                }' +
                    '            },' +
                    '            "query": {' +
                    '                "match_all_query": {' +
                    '                    "_type": "match_all_query"' +
                    '                }' +
                    '            }' +
                    '        }' +
                    '    },' +
                    '    "select": "(**)",' +
                    '    "sorts": [' +
                    '        {' +
                    '            "_type": "sort",' +
                    '            "field": "lastModified",' +
                    '            "sort_order": "asc"' +
                    '        }' +
                    '    ],' +
                    '    "start": 0,' +
                    '    "total": 2' +
                    '}';                    
                response.setHeader('Content-Type','application/json');
                response.setBody(body);
                response.setStatusCode(200);
                return response;
                
            }
            
        }            
        return response;
    }
    
}