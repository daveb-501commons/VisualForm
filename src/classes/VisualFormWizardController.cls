public with sharing class VisualFormWizardController {

    public Boolean managePeople { get; private set; } 
    public Boolean saveContact {get; set;}
    public String scaleImage {get; set;}
    public Integer scaleIndex {get; set;}
    public Integer scaleXClick {get; set;}
    public Integer scaleYClick {get; set;}
    Contact contact;
    Account account;

    public VisualFormWizardController() {
        scaleIndex = -1;
        updateScale();
    }
    
    public Contact getContact() {
        if(contact == null) contact = new Contact();
        return contact;
	}

    public Account getAccount() {
        if(account == null) account = new Account();
        return account;
	}
    
   	public PageReference step1() {
        return Page.VisualFormWizard;
   	}

   	public PageReference step2ManagePeople() {
        managePeople = True;
	    return Page.VisualFormWizardStep1;
   	}
    
   	public PageReference step2WorkDirectly() {
        managePeople = False;
	    return Page.VisualFormWizardStep1;
   	}

   	public PageReference step3() {
		return Page.VisualFormWizardStep2;
   	}

   	public PageReference step4() {
		return Page.VisualFormWizardStep3;
   	}
    
    public void updateScale() {
        system.debug('x: ' + scaleXClick + ' y: ' + scaleYClick);
        if (scaleIndex == 0) {
			scaleIndex = 100;            
        }
        else if (scaleIndex == 100) {
			scaleIndex = 200;            
        }
        else if (scaleIndex == 200) {
			scaleIndex = 1000;            
        }
        else if (scaleIndex == 1000) {
			scaleIndex = 5000;            
        }
        else if (scaleIndex == 5000) {
			scaleIndex = 10000;            
        }
        else if (scaleIndex == 10000) {
			scaleIndex = 10001;            
        }
        else if (scaleIndex == 10001) {
			scaleIndex = 0;            
        }
        else {
            scaleIndex = 0;
        }
        
        scaleImage = getScaleImage(scaleIndex);
    }

    private String getScaleImage(Integer scaleValue) {
        if (scaleValue == 100) {
            return '{!URLFOR($Resource.VisualFormWizard, \'images/Scale100.jpg\')}';
        }
        else if (scaleValue == 200) {
            return '{!URLFOR($Resource.VisualFormWizard, \'images/Scale200.jpg\')}';
        }
        else if (scaleValue == 1000) {
            return '{!URLFOR($Resource.VisualFormWizard, \'images/Scale1000.jpg\')}';
        }
        else if (scaleValue == 5000) {
            return '{!URLFOR($Resource.VisualFormWizard, \'images/Scale5000.jpg\')}';
        }
        else if (scaleValue == 10000) {
            return '{!URLFOR($Resource.VisualFormWizard, \'images/Scale10000.jpg\')}';
        }
        else if (scaleValue == 10001) {
            return '{!URLFOR($Resource.VisualFormWizard, \'images/Scale10000.jpg\')}';
        }
        
        return '{!URLFOR($Resource.VisualFormWizard, \'images/Scale0.jpg\')}';
    }
    
    public PageReference save() {

        if (saveContact) {
            
            String name = contact.LastName;
            List<String> nameTokens = name.split(' ');
            contact.FirstName = nameTokens[0];
            if (nameTokens.size() > 1) {
            	contact.LastName = name.right(name.length() - (nameTokens[0].length() + 1));
            }
            
        	insert contact;
        }

        PageReference redirectPage = new PageReference('http://joinvroom.org/');
        redirectPage.setRedirect(true);

        return redirectPage;
    }
}