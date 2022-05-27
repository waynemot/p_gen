# README

A password generator based on a Php project from https://warpconduit.net/password-generator
porting and enhancing the code to generate "railatively" ;-) random passwords that are
memorable character sequences.

* Built using Rails 5.2 and Ruby 2.6.4

* No actual database objects behind this, a couple of models are used to provide the interface and operation.

The generated passwords are 'scored' using the Dropbox **zxcvbn** password strength estimator,
https://github.com/dropbox/zxcvbn . This allows some comparison of the various settings
and how they effect the perceived hardness reported by the **zxcvbn** estimator.
