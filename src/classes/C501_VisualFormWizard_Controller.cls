public with sharing class C501_VisualFormWizard_Controller {

    public Boolean managePeople { get; private set; } 
    public String scaleImage {get; private set;}
    public String scalePeople {get; private set;}
    public String scaleText {get; private set;}
    private Integer scaleIndex {get; set;}
    public Integer scaleXClick {get; set;}
    public Integer scaleYClick {get; set;}
    public String formError {get; private set;}
    
    Contact contact;
    Account account;

    public C501_VisualFormWizard_Controller() {
        
        scaleIndex = 1;
        setScale(scaleIndex);
    }
    
    public Contact getContact() {
        
        if(contact == null) {
            contact = new Contact();
            contact.LastName = 'John Doe';
            contact.Email = 'youremail@domain.com';
            contact.C501_Zipcode__c = '12345';
        } 
        
        return contact;
    }

    public Account getAccount() {

        if(account == null) {
            account = new Account();  
            account.Name = 'Type your organization here';
            account.C501_Organization_Reach__c = 'Type or select an option';
            account.C501_Org_Language_Other__c = 'Type language here';
            account.C501_Org_SizeOther__c = 'Please Describe Here';
        } 
        
        return account;
    }
    
    public PageReference start() {
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
        
        if (managePeople) {
            return getOrgReach();
        }
        
        return getOrgSize();
    }
    
    public PageReference getOrgSize() {
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
    
    public void updateScale() {
        
        system.debug('*******************************************scaleXClick: ' + scaleXClick + ' scaleYClick: ' + scaleYClick);
        
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
        
        system.debug('*******************************************scaleValue: ' + scaleValue + ' setScale: scaleImage: ' + scaleImage + ' scalePeople: ' + scalePeople + ' scaleText: ' + scaleText);
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

        if (contact.LastName == 'John Doe' || String.isBlank(contact.LastName)) {
            formError = 'Invalid name';
            return getContactInfo();
        }
        if (contact.Email == 'youremail@domain.com' || !validateEmail(contact.Email)) {
            formError = 'Invalid email address';
            return getContactInfo();
        }
        if (contact.C501_Zipcode__c == '12345' || !Pattern.matches('^[0-9]{5}(?:-[0-9]{4})?$', contact.C501_Zipcode__c)) {
            formError = 'Invalid zipcode';
            return getContactInfo();
        }

        String name = contact.LastName;
        if (name.contains(' ')) {
            List<String> nameTokens = name.split(' ');
            contact.FirstName = nameTokens[0];
            contact.LastName = name.substring(nameTokens[0].length());
        }

        if (string.isBlank(account.name) || account.name == 'Type your organization here') {
            account.name = contact.LastName;
        }
        
        // Check for existing contact
        List<Contact> existingContactQuery = [SELECT Account.Name
                                       FROM Contact
                                       WHERE Email=:contact.Email AND LastName=:contact.LastName AND C501_VFW_Managed__c=TRUE
                                       LIMIT 1];
        if (!existingContactQuery.isEmpty()) {
            existingContactQuery[0].FirstName = contact.FirstName;
            existingContactQuery[0].LastName = contact.LastName;
            existingContactQuery[0].C501_Zipcode__c = contact.C501_Zipcode__c;
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

        C501_VFW_Settings__c standardVFWSetting = C501_VFW_Settings__c.getInstance('Standard');
        string redirectURL = standardVFWSetting.C501_VFW_Setting_Choice2_Redirect__c;
        if (managePeople) {
            redirectUrl = standardVFWSetting.C501_VFW_Setting_Choice1_Redirect__c;
        }
        
        PageReference redirectPage = new PageReference(redirectUrl);
        redirectPage.setRedirect(true);

        return redirectPage;
    }
    
}