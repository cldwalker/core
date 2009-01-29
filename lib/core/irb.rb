#from http://errtheblog.com/posts/9-drop-to-irb
# call with IRB.start_session(Kernel.binding) in script
require 'irb'

module IRB
  module ClassMethods
    def start_session(binding)
      IRB.setup(nil)

      workspace = WorkSpace.new(binding)

      if @CONF[:SCRIPT]
        irb = Irb.new(workspace, @CONF[:SCRIPT])
      else
        irb = Irb.new(workspace)
      end

      @CONF[:IRB_RC].call(irb.context) if @CONF[:IRB_RC]
      @CONF[:MAIN_CONTEXT] = irb.context

      trap("SIGINT") do
        irb.signal_handle
      end

      catch(:IRB_EXIT) do
        irb.eval_input
      end
    end
  end
end

