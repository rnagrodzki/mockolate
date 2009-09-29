package mockolate
{
    import asx.object.isA;
    
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.describeType;
    
    import mockolate.ingredients.Mockolate;
    import mockolate.sample.DarkChocolate;
    import mockolate.sample.Flavour;
    
    import org.flexunit.assertThat;
    import org.flexunit.async.Async;
    import org.hamcrest.core.not;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.nullValue;
    import org.hamcrest.object.strictlyEqualTo;
    
    public class StubbingMockolates
    {
        // shorthands
        public function proceedWhen(target:IEventDispatcher, eventName:String, timeout:Number=30000, timeoutHandler:Function=null):void
        {
            Async.proceedOnEvent(this, target, eventName, timeout, timeoutHandler);
        }
        
        [Before(async, timeout=30000)]
        public function prepareMockolates():void
        {
            proceedWhen(
                prepare(Flavour, DarkChocolate),
                Event.COMPLETE);
        }
        
        /*
           Stubbing for nice and strict mocks
        
           // stub api
           // stub: method
           // stub: property
           stub(instance:*, propertyOrMethod:String, ...matchers):Stub
           // stub: argument matchers
           .args(...matchers)
           // stub: return value
           .returns(value:*)
           .returns(value:Answer)
           // stub: throw error
           .throws(error:Error)
           // stub: function call
           .calls(fn:Function)
           // stub: event dispatch
           .dispatches(event:Event, delay:Number=0)
           // expect: receive count, useful to change/sequence return values
           .times(n:int)
           .never()
           .once() // strict mock stubs/expectations default to once()
           .twice()
           .thrice()
           .atLeast(n:int) // nice mocks default to atLeast(0)
           .atMost(n:int)
           // stub: expectation ordering
           .ordered(group:String="global")
         */
        
        [Test]
        public function stubbingPropertyGetter():void
        {
            var instance:Flavour = nice(Flavour);
            var answer:Object = "Butterscotch";
            
            stub(instance).property("name").returns(answer);
            
            assertThat(instance.name, strictlyEqualTo(answer));
        }
        
        [Test]
        public function stubbingMethod():void
        {
            var instance:Flavour = nice(Flavour);
            var answer:Object = nice(Flavour);
            
            stub(instance).method("combine").args(nullValue()).returns(answer);
            
            assertThat(instance.combine(null), strictlyEqualTo(answer));
        }
        
        [Test]
        public function stubbingMethodWithArgs():void
        {
            var instance:Flavour = nice(Flavour);
            var arg:Flavour = new DarkChocolate();
            var answer:Flavour = nice(Flavour);
            
            stub(instance).method("combine").args(arg).returns(answer);
            
            assertThat(instance.combine(arg), strictlyEqualTo(answer));
        }
        
        [Test]
        public function stubbingMethodWithArgMatchers():void
        {
            var instance:Flavour = nice(Flavour);
            var arg:Flavour = new DarkChocolate();
            var answer:Flavour = nice(Flavour);
            
            stub(instance).method("combine").args(strictlyEqualTo(arg)).returns(answer);
            
            assertThat(instance.combine(arg), strictlyEqualTo(answer));
        }
    }
}