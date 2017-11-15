class EventsTable
  class EventsError < RuntimeError
    def message
      'bad'
    end
  end

  def initialize(transitions)
    @transitions = transitions
  end

  def call(state, input)
    @transitions.fetch([state, input])
  rescue KeyError
    raise EventsError
  end
end

class StateMachine
  def initialize(transition_function, initial_state)
    @transition_function = transition_function
    @state = initial_state
  end

  attr_reader :state

  def send_input(input)
    @state, output = @transition_function.call(@state, input)
    output
  end
end

class EventsAnalysis
  STATE_TRANSITIONS = EventsTable.new(
      # State         Input     Next state      Output
      [:waiting_synch, :armSynched] => [:waiting_unsynch,  'good'],
      [:waiting_unsynch, :armUnsynched] => [:waiting_dc,  'good'],
      [:waiting_connect, :connected] => [:waiting_dc,  'good'],
      [:waiting_dc, :armSynched] => [:waiting_unsynch,  'good'],
      [:waiting_dc, :disconnect] => [:waiting_connect,  'good'],
      [:waiting_synch, :open] => [:waiting_synch,  'good'], #open is always valid, but don't modify the current state
      [:waiting_unsynch, :open] => [:waiting_unsynch,  'good'], #open is always valid, but don't modify the current state
      [:waiting_connect, :open] => [:waiting_connect,  'good'], #open is always valid, but don't modify the current state
      [:waiting_dc, :open] => [:waiting_dc,  'good'] #open is always valid, but don't modify the current state
  )

  def initialize(events)
    @events = events
    @state_machine = StateMachine.new(STATE_TRANSITIONS, :waiting_connect)
  end



  def match_events
    #checktimestamp
    for i in 0..(@events.length-1)
      if (@events[i+1] != nil)
        if (@events[i].split(',')[1].strip <= @events[i+1].split(',')[1].strip)
          puts 'good'
        elsif
        puts 'bad'
        end
      end
    end

    #checksynch
    for i in 0..(@events.length-1)
      if (@events[i+1] != nil)
        if (@events[i].split(',')[3].strip == 'armSynched')
          valid_state = true
          while (valid_state && @events[i].split(',')[3] != 'armUnsynched')
            puts 'good'
            i = i+1
          end
          valid_state = false
        end
      end
    end

    #checkconnected
    for i in 0..(@events.length-1)
      if (@events[i+1] != nil)
        if (@events[i].split(',')[3].strip == 'connected')
          valid_state = true
          while (valid_state && @events[i].split(',')[3] != 'disconnected')
            puts 'good'
            i = i+1
          end
          valid_state = false
        end
      end
    end

    state_machine = StateMachine.new(STATE_TRANSITIONS, :waiting_connect)

    #checksequence
    for i in 0..(@events.length-1)
      if (@events[i+1] != nil)
        state_machine.send_input(@events[i].split(',')[3].strip.to_sym)
      end
    end
  end
end

eventstest1 = EventsAnalysis.new(["timestamp,111,event,armSynched",
                                  "timestamp,222,event,open",
                                  "timestamp,222,event,open",
                                  "timestamp,333,event,armUnsynched"]) #response should be good if timestamp >= next
eventstest2 = EventsAnalysis.new(["timestamp,111,event,armSynched",
                                  "timestamp,222,event,open",
                                  "timestamp,222,event,open",
                                  "timestamp,333,event,armUnsynched"]) #response should be good if armSynched > anything > armUnsynched
eventstest3 = EventsAnalysis.new(["timestamp,111,event,connected",
                                  "timestamp,222,event,open",
                                  "timestamp,222,event,open",
                                  "timestamp,333,event,disconnected"]) #response should be good if connected > anything > disconnected
eventstest4 = EventsAnalysis.new(["timestamp,111,event,connected",
                                  "timestamp,222,event,armSynched",
                                  "timestamp,222,event,open",
                                  "timestamp,222,event,open",
                                  "timestamp,222,event,open",
                                  "timestamp,222,event,open",
                                  "timestamp,222,event,armUnsynched",
                                  "timestamp,333,event,disconnected",
                                  "timestamp,333,event,disconnected"]) #response should be good if connected, armSynched, armUnsynched,disconnected (anything in between)

#state machine switch case

#puts eventstest1.match_events
#puts eventstest2.match_events
#puts eventstest3.match_events
puts eventstest4.match_events
