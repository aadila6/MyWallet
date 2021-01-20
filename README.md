# Homework4-F19
### Abudureheman Adila

Things that I have implemented this week for MyWallet App.   

##### HomeView
For homeview, I turned off the auto generating accounts where I will start off with an empty account if the user is new. Then I also give user an option in my navigation bar a nagivation button where it will trigger an popup screen for user to entere a new account name. If the user left the account name section empty, then it will automatically generate the name by number of accounts plus one.  The call the API to write back the new account that user added. Then refresh the entire tableview by calling the API to rewrite my wallet class.
Then I also added the tableViewDelegate to add a tableView(didSelectRowAt) function to let user be able to click on the view. Also refresh the page, or to update my wallet Class when the time is needed to make sure everything is up to date.   


##### AccountView
For the account view, I simply have a account name label and will get updated whenever user clicks from the previous view. Then the amont is always updated as well and is up to date. There are four buttons on this view where user will be able to transfer money back and forth and everything is up to date. For deposit and withdraw, I simply called the given api functions for the operation, and most importantly, I update my wallet all the time, in order to update my amount thats showing on the screen. As for transfer, I added a UI picker which will present the user's accounts and the amount that they would like to transfer money to. I simply passed the selected picker number to the api where are let toAccoountNum and let fromAccount to transfer money and update my wallet. As for the delete button, I simply delete the user's account and go back which by backToHomeView() to present the previous view. I also made sure that the user will have the most updated info on the previous page as well.   

Also when calling from API, in order to avoice the delays. I did the following to fix.  
if let err = error {print("Error: \(err)")} else { //operations need to be done}   

