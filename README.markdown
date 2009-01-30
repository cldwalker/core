Description
===========

My extensions to core and standard ruby 1.8 classes, similar to the facets and activesupport gems.
Although my extensions are probably nothing new, they are unobtrusive (monkeypatching is up to you)
and have basic checks for preventing method name collision.
So if you're not feeling shy, monkeypatch: 

	irb>> require 'core'
	true
	irb>> Core.adds_to Array
	Array
	irb>> Core.ancestors
	=> [Array, Core::Array, Enumerable, Object, PP::ObjectMixin, Kernel]
	
And if you're not feeling your monkey-fu:
	
	irb>> class Base; class Array < Array; end; end
	=> nil
	irb>> Core.add_to Base::Array, :with=>Core::Array
	=>Base::Array
	irb>> Base::Array.ancestors
	=>[Base::Array, Array, Core::Array, Enumerable, Object, PP::ObjectMixin, Kernel]

So what happens when it's four o'clock in the morning and you monkeypatch the wrong way?

	irb>> module Core::Array; def is_a?(*args); puts "dunno, i'm sleepy!"; end; end
	nil
	irb>> Core.adds_to Array
	Couldn't include Core::Array into Array because the following methods conflict:
	is_a?

Phew, that was a close one. But wait, I really do think I know what I'm doing:

	irb>> Core.adds_to Array, :force=>true
	Array
	irb>> [1,2].is_a?(Array)
	dunno, i'm sleepy!
	=>nil
	
Hopefully you'll use the force option more wisely.	

Your Core
=========
If you'd like to wrap your own core extensions in say the original namespace MyCore:
	
	MyCore.send :include, Core::Load

You'll then be able to extend classes as in the examples above, replacing Core with MyCore.
To take advantage of the auto-requiring done by Core::Loader, place your extensions
in a directory mycore/ and make sure your $LOAD\_PATH contains mycore's parent directory.
In other words, `require 'mycore/array'` should be valid.

A basic template to wrap up your methods for a MyCore extension would look like:

	#in mycore/array.rb
	module MyCore
		module Array
      module ClassMethods
        #class methods for Array
      end

		  # instance methods for Array
			def blah
			end
			#....
		end
	end
	

Limitations
===========

Checks for method name collisions currently use \*instance\_methods and *methods of a class.
Patches for more thorough checks are welcome.

Todo
====

* Make it easier to share/install core extensions made by others ie sake-like.
* Import/Upgrade old tests for my extension classes.
* Provide aliasing for methods to bypass method name clashes.
* Use Ruby2Ruby to handpick methods to extend.
