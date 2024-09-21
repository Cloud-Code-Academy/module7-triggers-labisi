trigger AccountTrigger on Account (before insert,after insert) {
    if (trigger.isBefore) {
        for (Account acc : Trigger.new) {
            if (acc.Type == null) {
                acc.Type = 'Prospect';
            }
         
            if (acc.ShippingStreet != null || acc.ShippingCity != null || acc.ShippingState != null || acc.ShippingPostalCode != null || acc.ShippingCountry!= null) {
                acc.BillingStreet = acc.ShippingStreet;
                acc.BillingCity = acc.ShippingCity;
                acc.BillingState = acc.ShippingState;
                acc.BillingPostalCode = acc.ShippingPostalCode;
                acc.BillingCountry = acc.ShippingCountry;
            }
     
        if (acc.Phone != null && acc.Website != null && acc.Fax !=null) {
            acc.rating = 'Hot';
        }       
    }
    }
       
    List <Contact> newContacts = new List<Contact>();
    if (trigger.isAfter) {
       if (trigger.isInsert) {
        for (Account acc : trigger.new) {
            Contact con = new Contact();
            con.AccountId = acc.Id;
            con.LastName = 'DefaultContact';
            con.Email = 'default@email.com';
            newContacts.add(con);
        }
        insert newContacts;
       } 
    } 

}