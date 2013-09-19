describe "E2E: Testing MQ Example Page", ->

  beforeEach -> browser().navigateTo('/#/mqexample')

  it 'should allow you to chose an mq action after connecting', ->
    expect(element(":button:contains('Connect'):enabled").count()).toBe 1
    expect(element("select:hidden").count()).toBe 1

    element(":button:contains('Connect')").click()

    expect(element(":button:contains('Connect'):disabled").count()).toBe 1
    expect(element("select:visible").count()).toBe 1

  it 'should show you the appropriate mq view after selecting an action', ->
    element(":button:contains('Connect')").click()
    select('selectedAction').option 'Get channel status'
    mqView = element '[ng-include]'

    expect(mqView.count()).toBe 1
    expect(mqView.html()).toContain 'Channel Status'

  it 'should remove the appropriate mq view after clicking on close button', ->
    element(":button:contains('Connect')").click()
    select('selectedAction').option 'Get channel status'
    select('selectedAction').option 'Send messages'
    select('selectedAction').option 'Listen for messages'

    element("fieldset:contains('Send a message') button:contains('Close')").click()
    expect(element('[ng-include]').count()).toBe 2
    expect(element("fieldset:contains('Send a message')").count()).toBe 0


  it 'should not show actions/mq views when disconnected', ->
    element(":button:contains('Connect')").click()
    select('selectedAction').option 'Get channel status'
    element(":button:contains('Disconnect')").click()

    expect(element('[ng-include]').count()).toBe 0
    expect(element('select:hidden').count()).toBe 1
