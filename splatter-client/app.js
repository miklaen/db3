(function() { // We use this anonymous function to create a closure.

	var app = angular.module('splatter-web', ['ngResource']);
	//window.showfeed = "";

	app.factory('User', function($resource, $http) 
	{
		return $resource('http://annan.sqrawler.com/api/users/:id.json',{},{
		update: {method:'PUT'},
		follow: {method:'POST', url:'http://annan.sqrawler.com/api/users/follows/'},
		addsplatt: {method:'POST', url:'http://annan.sqrawler.com/api/splatts/'},
		unfollow: {method:'DELETE', url:'http://annan.sqrawler.com/api/users/follows/:id/:follows_id'}})
	});
	
	app.factory('SplattsFeed', function($resource) 
	{
		return $resource('http://annan.sqrawler.com/api/users/splatts-feed/:id.json',{},{
		getsplatts: {method:'GET',url:'http://annan.sqrawler.com/api/users/splatts/:id.json', isArray:true}});
	});

	app.controller('UserController', function(User, SplattsFeed) 
	{
    	// add your user code below
		//this.u = User.get({id: 1})
		//this.hello = "Hello, world";
		//this.feed = SplattsFeed.get({id: 1},function (data) {
			//console.log(data.splatt);
			//return (data.splatt)});
			//write the user to the console
					
		// add your user code above	
	});
	
	app.controller("ShowSplattsController", function(User, SplattsFeed) 
		{
		this.data = {};
		this.updateFeed = function(user) 
		{			
			SplattsFeed.getsplatts({id: this.data.id})
			.$promise.then(
        //success
			function( value ){user.feed.splatt = value});
			this.data = {} //clears the form}
			//Set the user and feed to be the user we just got
			
		}
	});	

	
	app.controller("DeleteUserController", function(User) 
	{
		this.data = {};
		this.deleteUser = function(user) 
		{	
			deleteId = this.data.id;			
			User.delete({id: deleteId});
			this.data = {} //clears the form
		}
	});	

	app.controller("UpdateUserController", function(User) 
	{	
		this.data = {};
		this.updateUser = function(user) 
		{	
			postData = {"user":{
				"name": this.data.name, 
  				"blurb": this.data.blurb 
			}}
			
				
			User.update({id: user.u.id},postData);
			this.data = {} //clears the form
		}
	}
	);
	
	app.controller("AddSplattController", function(User) 
	{	
		this.data = {};
		this.addSplatt = function(user) 
		{	
			postData = {"splatt":{
				"body": this.data.splatt, 
  				"user_id": user.u.id 
			}}
			
				
			User.addsplatt({},postData);
			this.data = {} //clears the form
		}
	}
	);
	
		app.controller("FollowUserController", function(User) 
	{	
		this.data = {};
		this.followUser = function(user) 
		{	
			followUserData = {"id": user.u.id,"follows_id": this.data.follows}
			User.follow({},followUserData);
			this.data = {} //clears the form
		}
	}
	);
	
		app.controller("UnfollowUserController", function(User) 
	{	
		this.data = {};
		this.unfollowUser = function(user) 
		{	
			User.unfollow({id: user.u.id,follows_id: this.data.follows},{});
			this.data = {} //clears the form
		}
	}
	);
	
	
	// add your form controller below
	app.controller("UpdateFormController", function(User, SplattsFeed) 
	{
		this.data = {};
		this.updateUser = function(user) 
		{			
			//Set the user from the api
			newUser = User.get({id: this.data.name});
			//Set the news feed from the api
			newFeed = SplattsFeed.get({id: this.data.name});
			//Set the user and feed to be the user we just got
			user.u = newUser;
			user.feed = newFeed;
			this.data = {} //clears the form
		}
	});	
	
	app.controller("NewUserFormController", function(User, $http) 
	{
		this.data = {};
		this.newUser = function(user) 
		{	
			postData = {"user":{
  				"email": this.data.email, 
  				"name": this.data.name, 
				"password": this.data.password,
  				"blurb": this.data.blurb 
			}}
			
			
			 User.save(postData);
			this.data = {} //clears the form
		}
	});	
    // add your form controller above
})();
