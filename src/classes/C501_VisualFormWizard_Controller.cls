public without sharing class C501_VisualFormWizard_Controller {

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
    
    public C501_VisualFormWizard_Controller() {
        
        nOrgSizePosition = 0;
        strLanguage = 'en-us';
        managePeople = false;
        strC501_VFW_Label_OrgNameDefault = '';
        strC501_VFW_Label_OrgReachDefault = '';
        strC501_VFW_Label_OrgSizeOtherDefault = '';
        strC501_VFW_Label_OrgLanguageOtherDefault = '';

        this.getAccount();
    }
    
    private Contact contact;
    public Contact getContact() {
        
        if (contact == null) {
            contact = new Contact();
            this.Contact.C501_VFW_Name__c = 'John Doe';
            this.Contact.C501_VFW_Email__c = 'youremail@domain.com';
            this.Contact.C501_VFW_Zipcode__c = '12345';
            this.Contact.C501_VFW_Managed__c = true;
        } 
        
        return contact;
    }

    private Account account;
    public Account getAccount() {

        if (this.account == null) {
            account = new Account();  
        } 
        
        return account;
    }

    public void saveOrgSize() {
        
        this.Account.C501_Org_Size__c = strOrgSize;
    }

    public void saveLabels() {
        this.Account.C501_VFW_Org_Name__c = strC501_VFW_Label_OrgNameDefault;
        this.Account.C501_Org_Language_Other__c = strC501_VFW_Label_OrgLanguageOtherDefault;
        this.Account.C501_Org_SizeOther__c = strC501_VFW_Label_OrgSizeOtherDefault;
        this.Account.C501_Organization_Reach__c = strC501_VFW_Label_OrgReachDefault;
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
        
        if (this.Account.C501_VFW_Org_Name__c != strC501_VFW_Label_OrgNameDefault) {
            this.Account.Name = this.Account.C501_VFW_Org_Name__c;
        }
            
        if (managePeople) {
            return getOrgReach();
        }
        
        return getOrgSize();
    }
    
    public PageReference getOrgSize() {

        strOrgSize = '100 or Less';
		this.Account.C501_Org_Size__c = strOrgSize;
            
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

        if (this.Contact.C501_VFW_Name__c == 'John Doe' || string.isBlank(this.Contact.C501_VFW_Name__c)) {
            this.Contact.C501_VFW_Name__c = 'John Doe';
            formError = strC501_VFW_Label_ContactErrorName;
            return null;
        }
        if (this.Contact.C501_VFW_Email__c == 'youremail@domain.com' || string.isBlank(this.Contact.C501_VFW_Email__c)) {
            this.Contact.C501_VFW_Email__c = 'youremail@domain.com';
            formError = strC501_VFW_Label_ContactErrorEmail;
            return null;
        }
        if (this.Contact.C501_VFW_Email__c.length() < 4 || !validateEmail(this.Contact.C501_VFW_Email__c)) {
            formError = strC501_VFW_Label_ContactErrorEmail;
            return null;
        }
        
        this.Contact.email = this.Contact.C501_VFW_Email__c;
        
        if (this.Contact.C501_VFW_Zipcode__c == '12345' || string.isBlank(this.Contact.C501_VFW_Zipcode__c)) {
            this.Contact.C501_VFW_Zipcode__c = '';
        }
        else if (!Pattern.matches('^[0-9]{5}(?:-[0-9]{4})?$', this.Contact.C501_VFW_Zipcode__c)) {
            formError = strC501_VFW_Label_ContactErrorZipCode;
            return null;
        }

        this.Contact.LastName = this.Contact.C501_VFW_Name__c;
        if (this.Contact.LastName.contains(' ')) {
            List<String> nameTokens = this.Contact.LastName.split(' ');
            this.Contact.FirstName = nameTokens[0];
            this.Contact.LastName = this.Contact.LastName.substring(nameTokens[0].length() + 1).deleteWhitespace();
        }

        if (string.isBlank(this.Account.name) || this.Account.name == strC501_VFW_Label_OrgNameDefault) {
            this.Account.name = this.Contact.LastName;
        }
        
        if (this.Account.C501_Org_SizeOther__c != strC501_VFW_Label_OrgSizeOtherDefault) {
            this.Account.C501_Org_Size__c = '';
            this.Account.C501_Org_SizeOther__c = this.Account.C501_Org_SizeOther__c;
        }
        else {
            this.Account.C501_Org_SizeOther__c = '';
            this.Account.C501_Org_Size__c = strOrgSize;
        }

        C501_VFW_Settings__c standardVFWSetting = getSettings();
        Boolean createLead = (standardVFWSetting == null) ? true : standardVFWSetting.C501_VFW_Setting_CreateLead__c;

        if (createLead) {
            // Check for existing lead
            List<Lead> existingLeadQuery = [SELECT Company
                                        FROM Lead
                                        WHERE Email=:this.Contact.Email
                                            AND LastName=:this.Contact.LastName
                                            AND C501_VFW_Managed__c = true
                                            AND Status <> 'Closed - Converted'
                                        LIMIT 1];
            if (!existingLeadQuery.isEmpty()) {
                
                existingLeadQuery[0].LeadSource = (managePeople) ? 'VROOM_PROVIDER_FUNNEL_MANAGER' : 'VROOM_PROVIDER_FUNNEL_DIRECT';
                existingLeadQuery[0].FirstName = this.Contact.FirstName;
                existingLeadQuery[0].C501_VFW_Zipcode__c = this.Contact.C501_VFW_Zipcode__c;
                existingLeadQuery[0].PostalCode = this.Contact.C501_VFW_Zipcode__c;
                existingLeadQuery[0].Company = this.Account.Name;
                
                existingLeadQuery[0].C501_Organization_Reach__c = this.Account.C501_Organization_Reach__c;
                existingLeadQuery[0].C501_Org_BulkPrinting__c = this.Account.C501_Org_BulkPrinting__c;
                
                existingLeadQuery[0].C501_Org_Language_English__c = this.Account.C501_Org_Language_English__c;
                existingLeadQuery[0].C501_Org_Language_Other__c = this.Account.C501_Org_Language_Other__c;
                existingLeadQuery[0].C501_Org_Language_Russian__c = this.Account.C501_Org_Language_Russian__c;
                existingLeadQuery[0].C501_Org_Language_Spanish__c = this.Account.C501_Org_Language_Spanish__c;
                existingLeadQuery[0].C501_Org_Language_Vietnamese__c = this.Account.C501_Org_Language_Vietnamese__c;
                
                existingLeadQuery[0].C501_Org_Size__c = this.Account.C501_Org_Size__c;
                existingLeadQuery[0].C501_Org_SizeOther__c = this.Account.C501_Org_SizeOther__c;
                
                update existingLeadQuery[0];
            }
            else {
                Lead lead = new Lead();

                lead.C501_VFW_Managed__c = true;
                lead.LeadSource = (managePeople) ? 'VROOM_PROVIDER_FUNNEL_MANAGER' : 'VROOM_PROVIDER_FUNNEL_DIRECT';
                lead.Email = this.Contact.Email;
                lead.LastName = this.Contact.LastName;
                lead.FirstName = this.Contact.FirstName;
                lead.C501_VFW_Zipcode__c = this.Contact.C501_VFW_Zipcode__c;
                lead.PostalCode = this.Contact.C501_VFW_Zipcode__c;
                lead.Company = this.Account.Name;
                
                lead.C501_Organization_Reach__c = this.Account.C501_Organization_Reach__c;
                lead.C501_Org_BulkPrinting__c = this.Account.C501_Org_BulkPrinting__c;
                
                lead.C501_Org_Language_English__c = this.Account.C501_Org_Language_English__c;
                lead.C501_Org_Language_Other__c = this.Account.C501_Org_Language_Other__c;
                lead.C501_Org_Language_Russian__c = this.Account.C501_Org_Language_Russian__c;
                lead.C501_Org_Language_Spanish__c = this.Account.C501_Org_Language_Spanish__c;
                lead.C501_Org_Language_Vietnamese__c = this.Account.C501_Org_Language_Vietnamese__c;
                
                lead.C501_Org_Size__c = this.Account.C501_Org_Size__c;
                lead.C501_Org_SizeOther__c = this.Account.C501_Org_SizeOther__c;

                insert lead;
            }
        }
        else {

            // Check for existing contact
            List<Contact> existingContactQuery = [SELECT Account.Name
                                        FROM Contact
                                        WHERE Email=:this.Contact.Email AND LastName=:this.Contact.LastName AND C501_VFW_Managed__c=TRUE
                                        LIMIT 1];
            if (!existingContactQuery.isEmpty()) {
                
                existingContactQuery[0].FirstName = this.Contact.FirstName;
                existingContactQuery[0].C501_VFW_Zipcode__c = this.Contact.C501_VFW_Zipcode__c;
                existingContactQuery[0].Account.Name = this.Account.Name;
                
                existingContactQuery[0].Account.C501_Organization_Reach__c = this.Account.C501_Organization_Reach__c;
                existingContactQuery[0].Account.C501_Org_BulkPrinting__c = this.Account.C501_Org_BulkPrinting__c;
                
                existingContactQuery[0].Account.C501_Org_Language_English__c = this.Account.C501_Org_Language_English__c;
                existingContactQuery[0].Account.C501_Org_Language_Other__c = this.Account.C501_Org_Language_Other__c;
                existingContactQuery[0].Account.C501_Org_Language_Russian__c = this.Account.C501_Org_Language_Russian__c;
                existingContactQuery[0].Account.C501_Org_Language_Spanish__c = this.Account.C501_Org_Language_Spanish__c;
                existingContactQuery[0].Account.C501_Org_Language_Vietnamese__c = this.Account.C501_Org_Language_Vietnamese__c;
                
                existingContactQuery[0].Account.C501_Org_Size__c = this.Account.C501_Org_Size__c;
                existingContactQuery[0].Account.C501_Org_SizeOther__c = this.Account.C501_Org_SizeOther__c;
                
                update existingContactQuery[0];
                update existingContactQuery[0].Account;
            }
            else {
                insert account;

                this.Contact.AccountId = this.Account.Id;
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