Windows Azure Deployment
========================

**WORK IN PROGRESS**

This directory provides guidance and tooling for deploying the 
Web Framework Benchmarks project on Windows Azure.


Introduction
------------

Windows Azure is a cloud computing platform and infrastructure, created by
Microsoft, for building, deploying and managing applications and services
through a global network of Microsoft-managed datacenters. It provides both
platform as a service (PaaS) and infrastructure as a service (IaaS) services
and supports many different programming languages, tools and frameworks,
including both Microsoft-specific and third-party software and systems.

Windows Azure's infrastructure as a service (IaaS) services support both
Windows Server and Linux virtual machines. Specifically, Ubuntu is supported
through a partnership with Canonical. That makes Windows Azure a viable
platform for running the Web Framework Benchmarks suite.


Architecture
------------

The deployed environment will be composed of:

* An affinity group to keep all resources in the same region.
* A storage account for the virtual disk images.
* A virtual network for conectivity between the VMs and, optionally,
  secure connection to on-premises networks or individual computers.
* An Ubuntu VM for the benchmark client.
* An Ubuntu VM for the Linux server.
* A Windows Server VM for the Windows server.
* A Windows Server VM for the Microsoft SQL Server database server.
* A cloud service for each VM for access over the Internet.


Requirements
------------

To deploy the Web Framework Benchmarks suite on Windows Azure you will need:

* A Windows Azure subscription. A [free trial](https://www.windowsazure.com/en-us/pricing/free-trial/)
  is available.
* Windows Azure Cross-platform Command Line Interface, available for
  [free download](https://www.windowsazure.com/en-us/downloads/#cmd-line-tools)
  for Windows, Mac and Linux.
  * On Ubuntu, run the provided `ubuntu-wacli-install.sh` script.
* (Windows only) [Cygwin](http://www.cygwin.com/) for Linux-compatible command line tools on Windows.
  A PowerShell script (InstallCygwin.ps1) is provided for easy, automatic installation.


Instructions
------------

* Install the requirements mentioned above.
* Download your Windows Azure publish settings file:
  * In a command prompt, run "azure account download".
  * Log in with your Windows Azure account credentials.
  * Let the browser save the file.
* Copy the file azure-deployment-configuration-model.txt to a new file named
  azure-deployment-configuration.sh.
* Edit azure-deployment-configuration.sh and configure it according to its
  embedded documentation.
* In a command prompt, run "bash azure-deployment.sh".


Billing
-------

On Windows Azure, a free trial account and member offers (e.g. MSDN) have by
default a spending limit of $0. When your usage exhausts the monthly amounts 
included in your offer, your service will be disabled for the remainder of 
that billing month. You have the option to continue using the services by
removing the spending limit.

To avoid consuming your credits (in case of an account with spending limit)
or incurring in charges (in case of an account without spending limit),
you can stop the virtual machines and, optionally, remove their disk images.
Virtual machines in state "Stopped (Deallocated)" don't incur in charges.
The disk images incur in (relatively small) storage charges.

For more information refer to
[Windows Azure Spending Limit](http://www.windowsazure.com/en-us/pricing/spending-limits/)
and [Pricing Overview](http://www.windowsazure.com/en-us/pricing/overview/).


Support
-------
* [Google Groups](https://groups.google.com/forum/?fromgroups=#!forum/framework-benchmarks)
  for support specific to the Web Framework Benchmarks project.
* [StackOverflow](http://stackoverflow.com/questions/tagged/azure) and
  [MSDN Forums](http://social.msdn.microsoft.com/Forums/en-US/category/windowsazureplatform,azuremarketplace,windowsazureplatformctp)
  for community help on Windows Azure.
* [Windows Azure Support](http://www.windowsazure.com/en-us/support/faq/)
  for support on Windows Azure by Microsoft. See the available
  [Options](http://www.windowsazure.com/en-us/support/options/) and
  [Plans](http://www.windowsazure.com/en-us/support/plans/).
