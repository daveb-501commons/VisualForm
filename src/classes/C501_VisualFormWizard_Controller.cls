public with sharing class C501_VisualFormWizard_Controller {

    public Boolean managePeople { get; private set; } 
    public String formError {get; private set;}
    public String strLanguage {get; private set;}
    public String strOrgSize {get; set;}
    public Integer nOrgSizePosition {get; set;}
    
    // Translated Labels
    public String strC501_VFW_Label_OrgNameDefault {get; set;}
    public String strC501_VFW_Label_OrgReachDefault {get; set;}
    public String strC501_VFW_Label_OrgSizeOtherDefault {get; set;}
    public String strC501_VFW_Label_OrgLanguageOtherDefault {get; set;}
    public String strC501_VFW_Label_ContactErrorName {get; set;}
    public String strC501_VFW_Label_ContactErrorEmail {get; set;}
    public String strC501_VFW_Label_ContactErrorZipCode {get; set;}
    
    Contact contact;
    Account account;

    public C501_VisualFormWizard_Controller() {
        
        nOrgSizePosition = 0;
        strLanguage = 'en-us';
        managePeople = false;
        strC501_VFW_Label_OrgNameDefault = '';
        strC501_VFW_Label_OrgReachDefault = '';
        strC501_VFW_Label_OrgSizeOtherDefault = '';
        strC501_VFW_Label_OrgLanguageOtherDefault = '';
    }
    
    public Contact getContact() {
        
        if (contact == null) {
            contact = new Contact();
            contact.C501_VFW_Name__c = 'John Doe';
            contact.C501_VFW_Email__c = 'youremail@domain.com';
            contact.C501_VFW_Zipcode__c = '12345';
            contact.C501_VFW_Managed__c = true;
        } 
        
        return contact;
    }

    public Account getAccount() {

        if (account == null) {
            account = new Account();  
        } 
        
        return account;
    }

    public void saveOrgSize() {
        
        account.C501_Org_Size__c = strOrgSize;
    }

    public void saveLabels() {
        account.C501_VFW_Org_Name__c = strC501_VFW_Label_OrgNameDefault;
        account.C501_Org_Language_Other__c = strC501_VFW_Label_OrgLanguageOtherDefault;
        account.C501_Org_SizeOther__c = strC501_VFW_Label_OrgSizeOtherDefault;
        account.C501_Organization_Reach__c = strC501_VFW_Label_OrgReachDefault;
    }
    
    public PageReference checkUrlParameters() {

        try {
            if (!string.isBlank(ApexPages.currentPage().getParameters().get('language'))) {
                strLanguage = ApexPages.currentPage().getParameters().get('language');
                if (strLanguage != 'es' && strLanguage != 'en-us') {
                    strLanguage = 'en-us';
                }
            }
        }
        catch (Exception e) {
			system.debug(e.getMessage());
        }

        try {
            if (!string.isBlank(ApexPages.currentPage().getParameters().get('managepeople'))) {
                
                String paramValue = ApexPages.currentPage().getParameters().get('managepeople');
                if (paramValue.equalsIgnoreCase('true')) {
                    managePeople = true;
                }
            }
        }
        catch (Exception e) {
			system.debug(e.getMessage());
        }

        try {
            if (ApexPages.currentPage().getUrl().containsIgnoreCase(Page.C501_VisualFormWizard_Choice.getUrl()) &&
               !string.isBlank(ApexPages.currentPage().getParameters().get('managepeople'))) {
                
                return getOrgName();
            }
        }
        catch (Exception e) {
			system.debug(e.getMessage());
        }
        
        return null;
    }

    public PageReference getOrgChoice() {
        return Page.C501_VisualFormWizard_Choice;
    }
    
    public PageReference managePeople() {
        managePeople = True;
        return getOrgName();
    }
    
    public PageReference workDirectly() {
        managePeople = False;
        return getOrgName();
    }

    public PageReference getOrgName() {
        return Page.C501_VisualFormWizard_OrgName;
    }

    public PageReference getOrgNameNext() {
        
        if (account.C501_VFW_Org_Name__c != strC501_VFW_Label_OrgNameDefault) {
            account.Name = account.C501_VFW_Org_Name__c;
        }
            
        if (managePeople) {
            return getOrgReach();
        }
        
        return getOrgSize();
    }
    
    public PageReference getOrgSize() {

        strOrgSize = '100 or Less';
		Account.C501_Org_Size__c = strOrgSize;
            
        return Page.C501_VisualFormWizard_OrgSize;
    }

    public PageReference getOrgSizeNext() {
        
        return Page.C501_VisualFormWizard_ContactInfo;
    }
    
    public PageReference getOrgLanguage() {
        return Page.C501_VisualFormWizard_OrgLanguage;
    }

    public PageReference getOrgReach() {
        return Page.C501_VisualFormWizard_OrgReach;
    }
    
    public PageReference getContactInfo() {
        return Page.C501_VisualFormWizard_ContactInfo;
    }
    
    public PageReference getContactInfoPrevious() {
        
        if (managePeople) {
            return getOrgLanguage();
        }
        
        return getOrgSize();
    }
    
    public static Boolean validateEmail(String email) {
        
        Boolean res = true;
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
    
        if (!MyMatcher.matches()) 
            res = false;
        return res; 
    }

    public C501_VFW_Settings__c getSettings() {

        C501_VFW_Settings__c standardVFWSetting = C501_VFW_Settings__c.getInstance('Production_English');
        if (strLanguage == 'es') {
            standardVFWSetting = C501_VFW_Settings__c.getInstance('Production_Spanish');
        }

        return standardVFWSetting;
    }

    public PageReference save() {

        formError = '';

        if (contact.C501_VFW_Name__c == 'John Doe' || string.isBlank(contact.C501_VFW_Name__c)) {
            contact.C501_VFW_Name__c = 'John Doe';
            formError = strC501_VFW_Label_ContactErrorName;
            return null;
        }
        if (contact.C501_VFW_Email__c == 'youremail@domain.com' || string.isBlank(contact.C501_VFW_Email__c)) {
            contact.C501_VFW_Email__c = 'youremail@domain.com';
            formError = strC501_VFW_Label_ContactErrorEmail;
            return null;
        }
        if (contact.C501_VFW_Email__c.length() < 4 || !validateEmail(contact.C501_VFW_Email__c)) {
            formError = strC501_VFW_Label_ContactErrorEmail;
            return null;
        }
        
        contact.email = contact.C501_VFW_Email__c;
        
        if (contact.C501_VFW_Zipcode__c == '12345' || string.isBlank(contact.C501_VFW_Zipcode__c)) {
            contact.C501_VFW_Zipcode__c = '';
        }
        else if (!Pattern.matches('^[0-9]{5}(?:-[0-9]{4})?$', contact.C501_VFW_Zipcode__c)) {
            formError = strC501_VFW_Label_ContactErrorZipCode;
            return null;
        }

        contact.LastName = contact.C501_VFW_Name__c;
        if (contact.LastName.contains(' ')) {
            List<String> nameTokens = contact.LastName.split(' ');
            contact.FirstName = nameTokens[0];
            contact.LastName = contact.LastName.substring(nameTokens[0].length() + 1).deleteWhitespace();
        }

        if (string.isBlank(account.name) || account.name == strC501_VFW_Label_OrgNameDefault) {
            account.name = contact.LastName;
        }
        
        if (account.C501_Org_SizeOther__c != strC501_VFW_Label_OrgSizeOtherDefault) {
            Account.C501_Org_Size__c = '';
            Account.C501_Org_SizeOther__c = account.C501_Org_SizeOther__c;
        }
        else {
            Account.C501_Org_SizeOther__c = '';
            Account.C501_Org_Size__c = strOrgSize;
        }

        C501_VFW_Settings__c standardVFWSetting = getSettings();
        Boolean createLead = (standardVFWSetting == null) ? true : standardVFWSetting.C501_VFW_Setting_CreateLead__c;

        if (createLead) {
            // Check for existing lead
            List<Lead> existingLeadQuery = [SELECT Company
                                        FROM Lead
                                        WHERE Email=:contact.Email AND LastName=:contact.LastName AND C501_VFW_Managed__c=true
                                        LIMIT 1];
            if (!existingLeadQuery.isEmpty()) {
                
                existingLeadQuery[0].LeadSource = (managePeople) ? 'VROOM_PROVIDER_FUNNEL_MANAGER' : 'VROOM_PROVIDER_FUNNEL_DIRECT';
                existingLeadQuery[0].FirstName = contact.FirstName;
                existingLeadQuery[0].C501_VFW_Zipcode__c = contact.C501_VFW_Zipcode__c;
                existingLeadQuery[0].PostalCode = contact.C501_VFW_Zipcode__c;
                existingLeadQuery[0].Company = account.Name;
                
                existingLeadQuery[0].C501_Organization_Reach__c = account.C501_Organization_Reach__c;
                existingLeadQuery[0].C501_Org_BulkPrinting__c = account.C501_Org_BulkPrinting__c;
                
                existingLeadQuery[0].C501_Org_Language_English__c = account.C501_Org_Language_English__c;
                existingLeadQuery[0].C501_Org_Language_Other__c = account.C501_Org_Language_Other__c;
                existingLeadQuery[0].C501_Org_Language_Russian__c = account.C501_Org_Language_Russian__c;
                existingLeadQuery[0].C501_Org_Language_Spanish__c = account.C501_Org_Language_Spanish__c;
                existingLeadQuery[0].C501_Org_Language_Vietnamese__c = account.C501_Org_Language_Vietnamese__c;
                
                existingLeadQuery[0].C501_Org_Size__c = account.C501_Org_Size__c;
                existingLeadQuery[0].C501_Org_SizeOther__c = account.C501_Org_SizeOther__c;
                
                update existingLeadQuery[0];
            }
            else {
                Lead lead = new Lead();

                lead.C501_VFW_Managed__c = true;
                lead.LeadSource = (managePeople) ? 'VROOM_PROVIDER_FUNNEL_MANAGER' : 'VROOM_PROVIDER_FUNNEL_DIRECT';
                lead.Email = contact.Email;
                lead.LastName = contact.LastName;
                lead.FirstName = contact.FirstName;
                lead.C501_VFW_Zipcode__c = contact.C501_VFW_Zipcode__c;
                lead.PostalCode = contact.C501_VFW_Zipcode__c;
                lead.Company = account.Name;
                
                lead.C501_Organization_Reach__c = account.C501_Organization_Reach__c;
                lead.C501_Org_BulkPrinting__c = account.C501_Org_BulkPrinting__c;
                
                lead.C501_Org_Language_English__c = account.C501_Org_Language_English__c;
                lead.C501_Org_Language_Other__c = account.C501_Org_Language_Other__c;
                lead.C501_Org_Language_Russian__c = account.C501_Org_Language_Russian__c;
                lead.C501_Org_Language_Spanish__c = account.C501_Org_Language_Spanish__c;
                lead.C501_Org_Language_Vietnamese__c = account.C501_Org_Language_Vietnamese__c;
                
                lead.C501_Org_Size__c = account.C501_Org_Size__c;
                lead.C501_Org_SizeOther__c = account.C501_Org_SizeOther__c;

                insert lead;
            }
        }
        else {

            // Check for existing contact
            List<Contact> existingContactQuery = [SELECT Account.Name
                                        FROM Contact
                                        WHERE Email=:contact.Email AND LastName=:contact.LastName AND C501_VFW_Managed__c=TRUE
                                        LIMIT 1];
            if (!existingContactQuery.isEmpty()) {
                
                existingContactQuery[0].FirstName = contact.FirstName;
                existingContactQuery[0].C501_VFW_Zipcode__c = contact.C501_VFW_Zipcode__c;
                existingContactQuery[0].Account.Name = account.Name;
                
                existingContactQuery[0].Account.C501_Organization_Reach__c = account.C501_Organization_Reach__c;
                existingContactQuery[0].Account.C501_Org_BulkPrinting__c = account.C501_Org_BulkPrinting__c;
                
                existingContactQuery[0].Account.C501_Org_Language_English__c = account.C501_Org_Language_English__c;
                existingContactQuery[0].Account.C501_Org_Language_Other__c = account.C501_Org_Language_Other__c;
                existingContactQuery[0].Account.C501_Org_Language_Russian__c = account.C501_Org_Language_Russian__c;
                existingContactQuery[0].Account.C501_Org_Language_Spanish__c = account.C501_Org_Language_Spanish__c;
                existingContactQuery[0].Account.C501_Org_Language_Vietnamese__c = account.C501_Org_Language_Vietnamese__c;
                
                existingContactQuery[0].Account.C501_Org_Size__c = account.C501_Org_Size__c;
                existingContactQuery[0].Account.C501_Org_SizeOther__c = account.C501_Org_SizeOther__c;
                
                update existingContactQuery[0];
                update existingContactQuery[0].Account;
            }
            else {
                insert account;

                contact.AccountId = account.Id;
                insert contact;
            }
        }
        
        return finish();
    }
    
    public PageReference finish() {

        C501_VFW_Settings__c standardVFWSetting = C501_VFW_Settings__c.getInstance('Production_English');
        if (strLanguage == 'es') {
            standardVFWSetting = C501_VFW_Settings__c.getInstance('Production_Spanish');
        }
        string redirectURL = (standardVFWSetting == null) ? 'nourl' : standardVFWSetting.C501_VFW_Setting_Choice2_Redirect__c;
        if (managePeople) {
            redirectUrl = (standardVFWSetting == null) ? 'nourl' : standardVFWSetting.C501_VFW_Setting_Choice1_Redirect__c;
        }

        PageReference redirectPage = new PageReference(redirectURL);
        redirectPage.setRedirect(true);

        return redirectPage;
    }
    
}