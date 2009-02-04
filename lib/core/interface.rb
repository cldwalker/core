# Exposes all methods that should be accessible from Core.
module Core
  module Interface #:nodoc:
    def default_library=(value); Manager.default_library=(value); end
    def default_library; Manager.default_library; end
    def libraries; Manager.libraries; end
    def create_library(*args); Manager.create_library(*args); end
    def extends(*args, &block); Loader.extends(*args, &block); end
    def verbose; Loader.verbose; end
    def verbose=(value); Loader.verbose=(value); end
  end
end
