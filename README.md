# war\_hotel
----
## Introduction

__war\_hotel__ is a Chef cookbook that fully configures a Tomcat Web server hotel.  What's a web server hotel?  It's a big server that can host a lot of instances of a web server and Web ARchives (WARs) in those instances. 

It's all driven by a specific Chef role that originates in Git, drives through a delivery pipeline, and ends up in a production Chef org and eventually assigned to the run list of a Chef node. An example role:

```
{
    "name": "war_hotel1",
    "description": "Web ARchive Hotel role for Hotel #1.",
    "chef_type": "role",
    "json_class": "Chef::Role",
    "override_attributes": {
      "war_hotel": {
        "id":"war_hotel1",
        "instances": [
		  {
		    "id": "instance1",
	            "docker_image": "tomcat:8.5",
	            "tomcat": {
	              "https_port":10443,
	              "http_port":10080,
	              "jmx_port":10099,
	              "config": {
	                "artifact_id":"test-instance1-tomcat-config",
	                "group_id":"com.bbt.bcb",
	                "version": "1.0.0"
	              }
	            },
		  	...
	  	    "wars": [
	  	        {
	  	          "artifact_id": "war1",
	  	          "group_id": "com.bbt.bcb",
	  	          "version": "1.0.0"
	                  "smoke_test_commands": [
	                    {
	                      "command": "curl -f http://localhost:10080/test-instance1-war1",
	                      "expected_return_code": 0
	                    },
	                    {
	                      "command": "curl -L  http://localhost:10080/test-instance1-war1 | grep \"test-instance1-war1 v1.0.0\"",
	                      "expected_return_code": 0
	                    },
		  	    ...
		     ]
		  }
		  ...
        ]
      }
    },
    "run_list": [
        "recipe[war_hotel::default]"
    ]
}
```

So when a machine that has the chef-client installed on it gets the above role assigned to the machine's run list, next time the chef-client runs the machine becomes the WAR Hotel, setting up all the Tomcat instances and installing (using Maven) all the indicated WARs automatically.

Some conventional behavior worth noting:

1. Any number of instances can be installed each with any number of WARs. It's up to you to optimize how many instances and WARs go on a machine.
2. The major version of Java can be specified for a particular instance of Tomcat. When a new instance is created, the latest version of Java specified in the Chef environment will be used; thereafter, updates to Java will be handled automatically. The minor versions will be taken care of automatically.
3. The instance of Tomcat is not a choice. If a new instance is created, the latest version of Tomcat specified in the Chef environment will be used; thereafter, updates to the Tomat version will be handled automatically.
4. Upgrades of WAR versions are handled by this war\_hotel cookbook

The remainder of this README describes how the major moving parts of the cookbook work, as well as describing the Test Kitchen test suite design in detail.

## Installing Tomcat


## Installing Java


## Creating a Tomcat Instance


## Installing the WARs using Maven


## Upgrading WARs


## Removing WARs


## WAR smoke_test 



