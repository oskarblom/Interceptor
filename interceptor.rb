module Interceptor
    
    def attach_interceptor(method_selection, &interceptor)     
        method_selection.each do |method_name|
            (class << self; self end).class_eval do
                orig_method_name = "orig_#{method_name}"                
                alias_method orig_method_name, method_name
                define_method method_name do |*args|
                    yield method(orig_method_name), *args                                    
                end
            end if self.respond_to? method_name.to_s       
        end if methods.respond_to? 'each'
        self
    end

end

class SwedishDict
    
    def initialize()
        @dictionary = {'car' => 'bil', 'chair' => 'stol'}
    end

    def translate(original_word)        
        @dictionary[original_word]
    end

end

normal_dict = SwedishDict.new
extended_dict = normal_dict.clone.extend(Interceptor)

extended_dict.attach_interceptor [:translate] do |meth, *args|
    puts "LOG: entering method"
    result = meth.call *args
    puts "LOG: got result '#{result}'"    
    puts "LOG: leaving method"
    result
end

puts normal_dict.translate 'car' 
# outputs:
# bil
puts extended_dict.translate 'car' #
# outputs:
# LOG: entering method
# LOG: got result 'bil'
# LOG: leaving method
# bil



