public with sharing class C501_VisualFormWizard_Controller {

    public Boolean managePeople { get; private set; } 
    public String scaleImage {get; private set;}
    public String scalePeople {get; private set;}
    public String scaleText {get; private set;}
    private Integer scaleIndex {get; set;}
    public Integer scaleXClick {get; set;}
    public Integer scaleYClick {get; set;}
    public String formError {get; private set;}
    public String strLanguage {get; private set;}
    public String strOrgReach {get; set;}
    public String strOrgSize {get; set;}
    public Integer strOrgSizePosition {get; set;}
    
    Contact contact;
    Account account;

    public C501_VisualFormWizard_Controller() {
        
        strOrgSizePosition = 0;
        scaleIndex = 1;
        setScale(scaleIndex);
        strLanguage = 'en-us';
        managePeople = false;
    }
    
    public Contact getContact() {
        
        if(contact == null) {
            contact = new Contact();
            contact.C501_VFW_Name__c = 'John Doe';
            contact.C501_VFW_Email__c = 'youremail@domain.com';
            contact.C501_VFW_Zipcode__c = '12345';
            contact.C501_VFW_Managed__c = true;
        } 
        
        return contact;
    }

    public Account getAccount() {

        if(account == null) {
            account = new Account();  
            account.C501_VFW_Org_Name__c = 'Type your organization here';
            account.C501_Organization_Reach__c = 'Select an option';
            account.C501_Org_Language_Other__c = 'Type language here';
            account.C501_Org_SizeOther__c = 'Please Describe Here';
            strOrgReach = 'Select an option';
        } 
        
        return account;
    }
    
    public void saveOrgReach() {
        
        account.C501_Organization_Reach__c = strOrgReach;
    }

    public void saveOrgSize() {
        
        account.C501_Org_Size__c = strOrgSize;
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
            if (!string.isBlank(ApexPages.currentPage().getParameters().get('managePeople'))) {
                managePeople = Boolean.valueOf(ApexPages.currentPage().getParameters().get('managePeople'));
            
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
        
        if (account.C501_VFW_Org_Name__c != 'Type your organization here') {
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
        
        account.C501_Org_Size__c = scaleText;

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
    
    public void updateScale() {
        
        scaleIndex = scaleXClick / 125;
        Integer indexXPosition = 125 * scaleIndex;
        if (scaleXClick < indexXPosition) {
            
            if (scaleIndex > 0) {
                scaleIndex--;
            }
        }
        else {
            
            if (scaleIndex < 7) {
                scaleIndex++;
            }
        }
        
        setScale(scaleIndex);
    }

    private void setScale(Integer scaleValue) {
        
        if (scaleValue == 2) {
            scaleImage = 'images/Bar2.svg';
            scalePeople = 'images/100_to_200.svg';
            scaleText = '100 to 200';
        }
        else if (scaleValue == 3) {
            scaleImage = 'images/Bar3.svg';
            scalePeople = 'images/200_to_500.svg';
            scaleText = '200 to 500';
        }
        else if (scaleValue == 4) {
            scaleImage = 'images/Bar4.svg';
            scalePeople = 'images/500_to_1k.svg';
            scaleText = '500 to 1000';
        }
        else if (scaleValue == 5) {
            scaleImage = 'images/Bar5.svg';
            scalePeople = 'images/Under_5k.svg';
            scaleText = 'Under 5,000';
        }
        else if (scaleValue == 6) {
            scaleImage = 'images/Bar6.svg';
            scalePeople = 'images/Under_10k.svg';
            scaleText = 'Under 10,000';
        }
        else if (scaleValue == 7) {
            scaleImage = 'images/Bar7.svg';
            scalePeople = 'images/Over_10k.svg';
            scaleText = 'Over 10,000';
        }
        else {
            scaleImage = 'images/Bar1.svg';
            scalePeople = 'images/100_or_Less.svg';
            scaleText = '100 or Less';
        }
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

    public PageReference save() {

        formError = '';
        
        if (contact.C501_VFW_Name__c == 'John Doe' || string.isBlank(contact.C501_VFW_Name__c)) {
            contact.C501_VFW_Name__c = 'John Doe';
            formError = 'Invalid name';
            return null;
        }
        if (contact.C501_VFW_Email__c == 'youremail@domain.com' || string.isBlank(contact.C501_VFW_Email__c)) {
            contact.C501_VFW_Email__c = 'youremail@domain.com';
            formError = 'Invalid email address';
            return null;
        }
        if (contact.C501_VFW_Email__c.length() < 4 || !validateEmail(contact.C501_VFW_Email__c)) {
            formError = 'Invalid email address';
            return null;
        }
        
        contact.email = contact.C501_VFW_Email__c;
        
        if (contact.C501_VFW_Zipcode__c == '12345' || string.isBlank(contact.C501_VFW_Zipcode__c)) {
            contact.C501_VFW_Zipcode__c = '';
        }
        else if (!Pattern.matches('^[0-9]{5}(?:-[0-9]{4})?$', contact.C501_VFW_Zipcode__c)) {
            formError = 'Invalid zipcode';
            return null;
        }

        contact.LastName = contact.C501_VFW_Name__c;
        if (contact.LastName.contains(' ')) {
            List<String> nameTokens = contact.LastName.split(' ');
            contact.FirstName = nameTokens[0];
            contact.LastName = contact.LastName.substring(nameTokens[0].length());
        }

        if (string.isBlank(account.name) || account.name == 'Type your organization here') {
            account.name = contact.LastName;
        }
        
        if (account.C501_Org_SizeOther__c != 'Please Describe Here') {
            Account.C501_Org_Size__c = '';
            Account.C501_Org_SizeOther__c = account.C501_Org_SizeOther__c;
        }
        else {
            Account.C501_Org_SizeOther__c = '';
        }

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
        
        return finish();
    }
    
    public PageReference finish() {

        C501_VFW_Settings__c standardVFWSetting = C501_VFW_Settings__c.getInstance('Sandbox');
        string redirectURL = standardVFWSetting.C501_VFW_Setting_Choice2_Redirect__c;
        if (managePeople) {
            redirectUrl = standardVFWSetting.C501_VFW_Setting_Choice1_Redirect__c;
        }
        
        PageReference redirectPage = new PageReference(redirectUrl);
        redirectPage.setRedirect(true);

        return redirectPage;
    }
    
}