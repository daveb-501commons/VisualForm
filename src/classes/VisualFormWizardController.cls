public with sharing class VisualFormWizardController {

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

    public VisualFormWizardController() {
        
        scaleIndex = 1;
        setScale(scaleIndex);
    }
    
    public Contact getContact() {
        
        if(contact == null) {
            contact = new Contact();
			contact.description = 'Please Describe Here';
            contact.LastName = 'John Doe';
            contact.Email = 'joinvroom@gmail.com';
            contact.title = '12345';
        } 
        
        return contact;
	}

    public Account getAccount() {

        if(account == null) {
        	account = new Account();  
			account.Name = 'Type your organization here';
        } 
        
        return account;
	}
    
   	public PageReference step1() {
        return Page.VisualFormWizard;
   	}

   	public PageReference step2() {
	    return Page.VisualFormWizardStep1;
   	}

   	public PageReference step2ManagePeople() {
        managePeople = True;
	    return step2();
   	}
    
   	public PageReference step2WorkDirectly() {
        managePeople = False;
	    return step2();
   	}

   	public PageReference step3() {
		return Page.VisualFormWizardStep2;
   	}

   	public PageReference step4() {
		return Page.VisualFormWizardStep3;
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
            return step4();
        }
        if (contact.Email == 'joinvroom@gmail.com' || !validateEmail(contact.Email)) {
            formError = 'Invalid email address';
            return step4();
        }
        if (contact.title == '12345' || !Pattern.matches('^[0-9]{5}(?:-[0-9]{4})?$', contact.title)) {
            formError = 'Invalid zipcode';
            return step4();
        }

        String name = contact.LastName;
        if (name.contains(' ')) {
            List<String> nameTokens = name.split(' ');
            contact.FirstName = nameTokens[0];
            contact.LastName = name.substring(nameTokens[0].length());
        }

        // Check for existing contact
        List<Contact> existingContactQuery = [SELECT Account.Name
                                       FROM Contact
                                       WHERE Email=:contact.Email
                                       LIMIT 1];
        if (!existingContactQuery.isEmpty()) {
            existingContactQuery[0].FirstName = contact.FirstName;
            existingContactQuery[0].LastName = contact.LastName;
            existingContactQuery[0].Title = contact.Title;
            existingContactQuery[0].Account.Name = account.Name;
            
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

        PageReference redirectPage = new PageReference('http://joinvroom.org/');
        redirectPage.setRedirect(true);

        return redirectPage;
    }
    
}