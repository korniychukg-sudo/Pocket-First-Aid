import SwiftUI

// MARK: - Models

struct AidCategory: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let art: String
    let tint: Color
    let soft: Color
}

struct AidEmergency: Identifiable {
    let id: String
    let categoryID: String
    let title: String
    let art: String
    let callFirst: Bool          // show "call emergency services now" banner on top
    let whenToCall: String       // when professional help is required
    let steps: [String]
    let donts: [String]
}

struct AidQuizQuestion: Identifiable {
    let id: Int
    let question: String
    let options: [String]
    let correct: Int
    let explanation: String
}

struct AidKit: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let art: String
    let items: [String]
}

struct EmergencyNumber: Identifiable {
    let region: String
    let number: String
    var id: String { region }
}

// MARK: - Content

enum AidContent {

    static let disclaimer = "Readycue: First Aid provides general educational information based on widely accepted first aid guidelines. It is not medical advice and does not replace professional training or emergency services. In any serious situation, call your local emergency number immediately."

    static let categories: [AidCategory] = [
        AidCategory(id: "bleeding", title: "Bleeding & Wounds", subtitle: "Cuts, scrapes and heavy bleeding", art: "cat_bleeding", tint: AidTheme.primary, soft: AidTheme.peach),
        AidCategory(id: "burns", title: "Burns & Scalds", subtitle: "Heat, chemicals and electricity", art: "cat_burns", tint: AidTheme.amber, soft: AidTheme.amberSoft),
        AidCategory(id: "breathing", title: "Breathing", subtitle: "Choking, asthma and allergies", art: "cat_breathing", tint: AidTheme.slate, soft: AidTheme.slateSoft),
        AidCategory(id: "heart", title: "Heart & Brain", subtitle: "Heart attack, stroke and fainting", art: "cat_heart", tint: AidTheme.primaryDeep, soft: AidTheme.peach),
        AidCategory(id: "bones", title: "Bones & Joints", subtitle: "Sprains, fractures and head injuries", art: "cat_bones", tint: AidTheme.slate, soft: AidTheme.slateSoft),
        AidCategory(id: "heatcold", title: "Heat & Cold", subtitle: "Heatstroke, hypothermia and frostbite", art: "cat_heatcold", tint: AidTheme.amber, soft: AidTheme.amberSoft),
        AidCategory(id: "bites", title: "Bites & Stings", subtitle: "Insects, ticks and animals", art: "cat_bites", tint: AidTheme.sage, soft: AidTheme.sageSoft),
        AidCategory(id: "poison", title: "Poisoning & Sugar", subtitle: "Toxins, gas and blood sugar", art: "cat_poison", tint: AidTheme.primary, soft: AidTheme.peach)
    ]

    static func category(_ id: String) -> AidCategory {
        categories.first { $0.id == id } ?? categories[0]
    }

    static func emergencies(in categoryID: String) -> [AidEmergency] {
        emergencies.filter { $0.categoryID == categoryID }
    }

    static let emergencies: [AidEmergency] = [

        // MARK: Bleeding & Wounds
        AidEmergency(
            id: "severe-bleeding", categoryID: "bleeding", title: "Severe Bleeding", art: "aid_severe_bleeding",
            callFirst: true,
            whenToCall: "Call emergency services now if blood is spurting, soaking through dressings, or the person feels faint.",
            steps: [
                "Have the person sit or lie down. If possible, ask them or a helper to call for emergency help right away.",
                "Press firmly on the wound with a clean cloth, gauze, or clothing. Use your whole hand and steady pressure.",
                "Keep pressing without lifting the cloth. If blood soaks through, add more layers on top - never remove the soaked ones.",
                "If a limb is bleeding, keep pressure on and raise the limb above heart level while you wait.",
                "Once bleeding slows, wrap a firm bandage over the dressing to hold the pressure in place.",
                "Keep the person warm and still until help arrives. Watch for pale skin, sweating, or drowsiness."
            ],
            donts: [
                "Do not remove blood-soaked dressings - always add layers on top.",
                "Do not remove any object embedded in the wound; press around it instead.",
                "Do not give food or drink in case surgery is needed."
            ]),
        AidEmergency(
            id: "cuts-scrapes", categoryID: "bleeding", title: "Cuts & Scrapes", art: "aid_cuts",
            callFirst: false,
            whenToCall: "See a medical professional if the cut is deep, gapes open, will not stop bleeding after 10 minutes, or shows signs of infection later.",
            steps: [
                "Wash your hands first so you do not introduce germs into the wound.",
                "Rinse the wound under clean running water to flush out dirt.",
                "Pat the area dry with a clean cloth, working away from the wound.",
                "Press gently with clean gauze until any bleeding stops - small cuts usually stop within minutes.",
                "Apply a thin layer of antiseptic if you have it, then cover with a plaster or sterile dressing.",
                "Change the dressing daily and watch for growing redness, swelling, warmth, or pus."
            ],
            donts: [
                "Do not blow on the wound or touch it with dirty fingers.",
                "Do not use cotton wool directly on an open wound - fibers stick.",
                "Do not ignore redness that spreads after a day or two."
            ]),
        AidEmergency(
            id: "nosebleed", categoryID: "bleeding", title: "Nosebleed", art: "aid_nosebleed",
            callFirst: false,
            whenToCall: "Seek urgent help if bleeding lasts more than 20 minutes, follows a hard blow to the head, or the person takes blood thinners.",
            steps: [
                "Sit the person down and lean them slightly forward - never backward.",
                "Pinch the soft part of the nose, just below the bony bridge, firmly between finger and thumb.",
                "Hold the pinch for a full 10 minutes without peeking. Breathe through the mouth.",
                "A cold pack on the bridge of the nose or the back of the neck can help slow the bleeding.",
                "After 10 minutes, release slowly. If bleeding continues, pinch for another 10 minutes.",
                "Once it stops, rest quietly. Avoid nose blowing, heavy lifting, and hot drinks for a few hours."
            ],
            donts: [
                "Do not tilt the head back - blood running down the throat causes nausea.",
                "Do not stuff tissues or cotton inside the nostril.",
                "Do not pick or blow the nose for several hours after it stops."
            ]),
        AidEmergency(
            id: "splinter", categoryID: "bleeding", title: "Embedded Splinter", art: "aid_splinter",
            callFirst: false,
            whenToCall: "See a professional if the splinter is deep, under a nail, near the eye, or the area becomes infected.",
            steps: [
                "Wash your hands and gently clean the skin around the splinter with soap and water.",
                "Clean a pair of tweezers with an alcohol wipe or by boiling water over them.",
                "Grip the splinter as close to the skin as possible and pull it out at the same angle it went in.",
                "Squeeze the area gently so a drop of blood flushes the track, then rinse again.",
                "Apply antiseptic and cover with a plaster.",
                "Check the spot over the next days for redness, swelling, or tenderness."
            ],
            donts: [
                "Do not dig into the skin with a needle - if you cannot grip it, get help.",
                "Do not squeeze hard around glass splinters; they can break apart.",
                "Do not leave large or dirty splinters in place hoping they work out on their own."
            ]),

        // MARK: Burns & Scalds
        AidEmergency(
            id: "thermal-burn", categoryID: "burns", title: "Heat Burn or Scald", art: "aid_thermal_burn",
            callFirst: false,
            whenToCall: "Call emergency services for burns that are large, deep, white or charred, on the face, hands, or joints, or on a child.",
            steps: [
                "Move the person away from the heat source and stop the burning process.",
                "Cool the burn under cool running water for a full 20 minutes. This is the single most useful step.",
                "While cooling, remove rings, watches, and loose clothing near the burn before swelling starts.",
                "After cooling, cover the burn loosely with cling film or a clean, non-fluffy cloth.",
                "Keep the person warm overall - cool the burn, not the person.",
                "Give an over-the-counter pain reliever if needed and keep the area raised to limit swelling."
            ],
            donts: [
                "Do not use ice, butter, toothpaste, or creams on a fresh burn.",
                "Do not burst blisters - they protect the skin underneath.",
                "Do not pull off clothing stuck to the burn."
            ]),
        AidEmergency(
            id: "chemical-burn", categoryID: "burns", title: "Chemical Burn", art: "aid_chemical_burn",
            callFirst: true,
            whenToCall: "Call emergency services or poison control for any chemical burn beyond a tiny spot, and always for the eyes or face.",
            steps: [
                "Protect your own hands with gloves or a cloth before helping.",
                "Brush off any dry chemical powder with a cloth before rinsing.",
                "Rinse the area with a steady stream of cool water for at least 20 minutes, keeping runoff away from unburned skin and eyes.",
                "Remove contaminated clothing and jewelry while rinsing, cutting clothes off if needed.",
                "If an eye is affected, rinse it continuously from the nose outward and keep the person blinking.",
                "Cover loosely with a clean cloth and get medical advice, bringing the chemical container or its name."
            ],
            donts: [
                "Do not try to neutralize a chemical with another chemical.",
                "Do not rub the skin or eyes.",
                "Do not delay rinsing to search for antidotes - water first."
            ]),
        AidEmergency(
            id: "electrical-burn", categoryID: "burns", title: "Electrical Injury", art: "aid_electrical",
            callFirst: true,
            whenToCall: "Call emergency services for any electrical injury beyond a minor static shock - internal damage can be invisible.",
            steps: [
                "Do not touch the person until you are certain the power is off. Switch off at the source or unplug.",
                "If you cannot switch it off, push the source away with something dry and non-conductive, like a wooden broom.",
                "Once safe, check if the person is responsive and breathing normally.",
                "If they are unresponsive and not breathing normally, start CPR and send someone for a defibrillator.",
                "Cool any visible burns with cool running water and cover loosely.",
                "Keep the person still and warm until help arrives, even if they say they feel fine."
            ],
            donts: [
                "Do not approach anyone in contact with high-voltage lines - stay well back and call for help.",
                "Do not use anything wet or metallic to separate the person from the source.",
                "Do not let the person walk away without assessment - heart rhythm problems can appear later."
            ]),
        AidEmergency(
            id: "sunburn", categoryID: "burns", title: "Sunburn", art: "aid_sunburn",
            callFirst: false,
            whenToCall: "Seek medical advice for widespread blistering, fever, chills, dizziness, or sunburn on a baby.",
            steps: [
                "Get out of the sun - indoors or into deep shade.",
                "Cool the skin with a cool shower, bath, or damp towels for 10 to 15 minutes.",
                "Drink plenty of water - sunburn pulls fluid to the skin and dehydrates you.",
                "Apply a fragrance-free moisturizer or aloe gel to intact skin while it is still damp.",
                "Take an over-the-counter pain reliever if needed for pain and inflammation.",
                "Cover up completely, staying out of the sun until the skin has fully healed."
            ],
            donts: [
                "Do not pop blisters - cover them loosely if they burst on their own.",
                "Do not apply petroleum jelly, butter, or heavy oils to fresh sunburn.",
                "Do not go back into the sun with already burned skin, even with sunscreen."
            ]),

        // MARK: Breathing
        AidEmergency(
            id: "choking-adult", categoryID: "breathing", title: "Choking (Adult & Child)", art: "aid_choking",
            callFirst: true,
            whenToCall: "If the person cannot breathe, cough, or speak, have someone call emergency services immediately while you act.",
            steps: [
                "Ask loudly: are you choking? If they can cough or speak, encourage them to keep coughing.",
                "If they cannot breathe or make sound, stand behind them and lean them well forward.",
                "Give up to 5 sharp blows between the shoulder blades with the heel of your hand. Check the mouth after each.",
                "If that fails, give up to 5 abdominal thrusts: fist above the navel, other hand on top, pull sharply inward and upward.",
                "Alternate 5 back blows and 5 thrusts until the object comes out or help arrives.",
                "If the person becomes unresponsive, lower them to the floor and start CPR - chest compressions can dislodge the object."
            ],
            donts: [
                "Do not sweep the mouth blindly with your fingers - you can push the object deeper.",
                "Do not give abdominal thrusts to a pregnant person; use chest thrusts instead.",
                "Do not leave the person alone while they are still choking."
            ]),
        AidEmergency(
            id: "choking-infant", categoryID: "breathing", title: "Choking (Infant)", art: "aid_choking_infant",
            callFirst: true,
            whenToCall: "If a baby cannot cry, cough, or breathe, have someone call emergency services immediately while you act.",
            steps: [
                "Sit down and lay the baby face down along your forearm, head lower than the chest, supporting the jaw with your fingers.",
                "Give up to 5 firm back blows between the shoulder blades with the heel of your free hand.",
                "Turn the baby face up along your other arm, head still low. Look in the mouth and remove anything you can see easily.",
                "If still choking, place two fingertips on the center of the chest just below the nipple line and give up to 5 sharp chest thrusts.",
                "Repeat cycles of 5 back blows and 5 chest thrusts until the object clears or help arrives.",
                "If the baby becomes unresponsive, start infant CPR immediately."
            ],
            donts: [
                "Do not give abdominal thrusts to a baby under one year.",
                "Do not sweep the baby's mouth blindly with a finger.",
                "Do not shake the baby."
            ]),
        AidEmergency(
            id: "asthma", categoryID: "breathing", title: "Asthma Attack", art: "aid_asthma",
            callFirst: false,
            whenToCall: "Call emergency services if there is no inhaler, symptoms do not ease after the first rounds of puffs, the person cannot speak in sentences, or lips turn bluish.",
            steps: [
                "Help the person sit upright, slightly forward. Stay calm and speak reassuringly.",
                "Help them use their own reliever inhaler, usually blue: one puff at a time with slow, deep breaths.",
                "Follow their personal action plan if they have one; a common pattern is up to 10 puffs, one every 30 to 60 seconds.",
                "Loosen tight clothing and move away from any obvious trigger like smoke, dust, or cold air.",
                "If there is no improvement after the puffs, call emergency services and repeat the puffs while waiting.",
                "Keep them sitting upright the whole time - do not lie them down."
            ],
            donts: [
                "Do not lie the person flat.",
                "Do not leave them alone during a serious attack.",
                "Do not assume it will pass on its own if breathing keeps getting harder."
            ]),
        AidEmergency(
            id: "anaphylaxis", categoryID: "breathing", title: "Severe Allergic Reaction", art: "aid_allergy",
            callFirst: true,
            whenToCall: "Call emergency services immediately for swelling of the face or throat, trouble breathing, widespread hives with dizziness, or collapse after an exposure.",
            steps: [
                "Call for emergency help right away - anaphylaxis can worsen within minutes.",
                "Ask about an epinephrine auto-injector. Help the person use it on the outer thigh as trained; it can go through clothing.",
                "Note the time of the injection so you can tell responders.",
                "Lie the person down with legs raised. If breathing is hard, let them sit up; if pregnant, lie them on their left side.",
                "Remove the trigger if possible - for a stinger, scrape it off sideways with a card edge.",
                "If symptoms have not improved after 5 minutes and a second injector is available, use it. Stay until help arrives."
            ],
            donts: [
                "Do not have the person stand up or walk suddenly - it can cause collapse.",
                "Do not wait to see if it gets better before calling for help.",
                "Do not rely on antihistamines alone for a severe reaction - they are far too slow."
            ]),

        // MARK: Heart & Brain
        AidEmergency(
            id: "heart-attack", categoryID: "heart", title: "Heart Attack", art: "aid_heart_attack",
            callFirst: true,
            whenToCall: "Call emergency services for chest pressure or pain lasting more than a few minutes, especially with sweating, nausea, or pain spreading to the arm, jaw, or back.",
            steps: [
                "Call emergency services immediately. Minutes matter for heart muscle.",
                "Help the person into a comfortable position: half-sitting, knees bent, back supported works well.",
                "Loosen tight clothing at the neck, chest, and waist.",
                "Keep them calm and still - no walking around, no driving themselves anywhere.",
                "The emergency dispatcher may advise chewing an aspirin if the person is not allergic - follow the dispatcher's instructions.",
                "If they become unresponsive and stop breathing normally, start CPR at once and send someone for a defibrillator."
            ],
            donts: [
                "Do not wait for the pain to pass before calling for help.",
                "Do not let the person drive themselves to the hospital.",
                "Do not give food or drink."
            ]),
        AidEmergency(
            id: "stroke", categoryID: "heart", title: "Stroke", art: "aid_stroke",
            callFirst: true,
            whenToCall: "Call emergency services at the first sign - treatments work best within the first hours.",
            steps: [
                "Think FAST. Face: ask them to smile - does one side droop?",
                "Arms: ask them to raise both arms - does one drift downward?",
                "Speech: ask them to repeat a simple sentence - is it slurred or strange?",
                "Time: if you see any one of these signs, call emergency services immediately and note the exact time symptoms started.",
                "Help the person lie down with head and shoulders slightly raised. Keep them still and reassured.",
                "Do not give anything to eat or drink - swallowing may be affected. If they become unresponsive but breathe normally, place them on their side."
            ],
            donts: [
                "Do not give food, drink, or any medication, including aspirin.",
                "Do not wait to see if symptoms pass - even brief symptoms need emergency care.",
                "Do not let them sleep it off."
            ]),
        AidEmergency(
            id: "fainting", categoryID: "heart", title: "Fainting", art: "aid_fainting",
            callFirst: false,
            whenToCall: "Call emergency services if the person does not wake within a minute, fainted during exercise, has chest pain, or is pregnant or elderly.",
            steps: [
                "If someone feels faint, help them lie down before they fall, and raise their legs on a chair or your shoulder.",
                "If they have already fainted, check they are breathing normally, then raise their legs about 30 centimeters.",
                "Loosen tight collars and belts and make sure they have fresh air.",
                "They should come around within a minute. Keep them lying down for several more minutes.",
                "Help them sit up slowly in stages. Standing too fast can cause a second faint.",
                "A drink of water and a snack can help once they are fully alert and able to swallow."
            ],
            donts: [
                "Do not sit or stand them up quickly.",
                "Do not splash water on their face or shake them.",
                "Do not give food or drink until they are fully awake."
            ]),
        AidEmergency(
            id: "seizure", categoryID: "heart", title: "Seizure", art: "aid_seizure",
            callFirst: false,
            whenToCall: "Call emergency services if a seizure lasts over 5 minutes, repeats, happens in water, injures the person, or is their first ever seizure.",
            steps: [
                "Stay calm and note the time the seizure starts - the duration matters.",
                "Clear away hard or sharp objects and put something soft under the head.",
                "Loosen anything tight around the neck and remove glasses.",
                "Let the seizure run its course. Never hold the person down or put anything in their mouth.",
                "When jerking stops, roll them gently onto their side with the head tilted slightly back to keep the airway clear.",
                "Stay with them as they wake. They may be confused for a while - speak calmly and explain what happened."
            ],
            donts: [
                "Do not restrain the person or try to stop the movements.",
                "Do not put anything between their teeth - they cannot swallow their tongue.",
                "Do not give food or water until they are fully alert."
            ]),

        // MARK: Bones & Joints
        AidEmergency(
            id: "sprain", categoryID: "bones", title: "Sprained Ankle or Wrist", art: "aid_sprain",
            callFirst: false,
            whenToCall: "Get an X-ray if the joint cannot bear weight, looks deformed, or pain centers on the bone rather than the soft tissue.",
            steps: [
                "Stop the activity and get the weight off the joint straight away.",
                "Rest: avoid using the joint for the first day or two.",
                "Ice: apply a cold pack wrapped in a thin cloth for 15 to 20 minutes every 2 to 3 hours.",
                "Compression: wrap the joint firmly but not tightly with an elastic bandage, from below the joint upward.",
                "Elevation: keep the limb raised above heart level as much as possible.",
                "After 48 hours, begin gentle movement as pain allows. If it is not clearly improving in a few days, get it checked."
            ],
            donts: [
                "Do not apply ice directly to bare skin.",
                "Do not wrap so tightly that toes or fingers tingle or go pale.",
                "Do not push through sharp pain in the first days."
            ]),
        AidEmergency(
            id: "fracture", categoryID: "bones", title: "Suspected Broken Bone", art: "aid_fracture",
            callFirst: false,
            whenToCall: "Call emergency services for suspected breaks of the thigh, hip, pelvis, or spine, for bone through the skin, or if the limb is cold, pale, or numb below the injury.",
            steps: [
                "Keep the person still and support the injured part in the position found.",
                "Do not try to straighten the limb. Support it with your hands, rolled towels, or cushions.",
                "For an arm, let the person support it against their body; padding and a sling can help if trained.",
                "Apply a wrapped cold pack around, not on, obvious deformity to limit swelling.",
                "Cover any open wound near the break with a clean dressing without pressing on bone.",
                "Get the person to emergency care, keeping the limb as still as possible on the way."
            ],
            donts: [
                "Do not straighten, push back, or test a deformed limb.",
                "Do not let the person eat or drink in case surgery is needed.",
                "Do not move someone with a suspected spine, hip, or pelvis injury unless they are in immediate danger."
            ]),
        AidEmergency(
            id: "head-injury", categoryID: "bones", title: "Head Injury", art: "aid_head_injury",
            callFirst: false,
            whenToCall: "Call emergency services for loss of consciousness, repeated vomiting, worsening headache, confusion, unequal pupils, seizures, or clear fluid from nose or ears.",
            steps: [
                "Sit the person down and apply a wrapped cold pack to the bump for up to 20 minutes.",
                "Check what happened and whether they blacked out, even briefly.",
                "Watch them closely for the next hours: alertness, speech, balance, and memory.",
                "Treat any scalp wound with gentle direct pressure and a dressing - scalps bleed a lot even from small cuts.",
                "Let them rest, but check on them regularly, including at least once during the first night.",
                "Keep them away from sport, screens, and alcohol until symptoms fully settle."
            ],
            donts: [
                "Do not leave a person alone in the first hours after a significant blow to the head.",
                "Do not give alcohol, sedatives, or blood-thinning painkillers.",
                "Do not let them return to sport the same day, even if they feel fine."
            ]),
        AidEmergency(
            id: "spinal", categoryID: "bones", title: "Suspected Spinal Injury", art: "aid_spinal",
            callFirst: true,
            whenToCall: "Call emergency services for neck or back pain after a fall from height, a dive, or a crash, or for any numbness, tingling, or weakness in limbs.",
            steps: [
                "Call for emergency help before anything else and tell them a spinal injury is suspected.",
                "Tell the person to stay completely still. Kneel behind their head.",
                "Steady the head with a hand on each side, holding it in line with the spine, and keep holding.",
                "If they are wearing a helmet, leave it on unless it blocks breathing.",
                "If they vomit or you must leave them, roll them as one unit onto their side with helpers keeping head and spine aligned.",
                "Keep them warm and keep talking to them calmly until responders take over."
            ],
            donts: [
                "Do not move the person unless there is immediate danger like fire or traffic.",
                "Do not put a pillow under the head or bend the neck.",
                "Do not remove a helmet unless the airway is blocked."
            ]),

        // MARK: Heat & Cold
        AidEmergency(
            id: "heatstroke", categoryID: "heatcold", title: "Heatstroke", art: "aid_heatstroke",
            callFirst: true,
            whenToCall: "Call emergency services for hot skin with confusion, staggering, or collapse in heat - heatstroke is life-threatening.",
            steps: [
                "Call for emergency help, then move the person to the coolest place available immediately.",
                "Remove excess clothing and start cooling aggressively - this cannot wait.",
                "Cover them with cool wet sheets or towels, or sponge them with cool water everywhere you can.",
                "Fan them constantly and put wrapped cold packs in the armpits, on the neck, and in the groin.",
                "If they are fully alert, give small sips of cool water. Nothing by mouth if drowsy.",
                "If they become unresponsive but breathe normally, place them on their side and continue cooling until help arrives."
            ],
            donts: [
                "Do not waste time - cooling comes before everything except the emergency call.",
                "Do not give fluids to a confused or drowsy person.",
                "Do not use ice-cold immersion on an elderly or collapsed person without medical guidance."
            ]),
        AidEmergency(
            id: "heat-exhaustion", categoryID: "heatcold", title: "Heat Exhaustion", art: "aid_heat_exhaustion",
            callFirst: false,
            whenToCall: "Call emergency services if the person becomes confused, stops sweating with hot skin, or is not improving after 30 minutes of cooling and fluids.",
            steps: [
                "Move the person to a cool, shaded place and have them lie down with legs slightly raised.",
                "Remove unnecessary clothing and cool the skin with damp cloths or a cool shower.",
                "Fan them while the skin is damp - evaporation is what cools.",
                "Give plenty of water or a sports drink in steady sips.",
                "Stay with them. They should start feeling better within 30 minutes.",
                "Keep them resting in the cool for the remainder of the day, even after they recover."
            ],
            donts: [
                "Do not let them return to activity or heat the same day.",
                "Do not give alcohol or very sugary drinks.",
                "Do not ignore worsening confusion - that is heatstroke territory."
            ]),
        AidEmergency(
            id: "hypothermia", categoryID: "heatcold", title: "Hypothermia", art: "aid_hypothermia",
            callFirst: true,
            whenToCall: "Call emergency services for intense shivering that stops, slurred speech, clumsiness, drowsiness, or confusion in the cold.",
            steps: [
                "Call for help, then get the person out of the cold, wind, and wet - indoors or into shelter.",
                "Remove wet clothing gently and replace with dry layers, covering the head and neck.",
                "Wrap them in blankets or sleeping bags, adding insulation under them as well.",
                "Warm them gradually with warm - not hot - packs wrapped in cloth on the chest, armpits, and groin.",
                "If fully alert, give warm sweet drinks. No alcohol, no caffeine.",
                "Handle them very gently and keep them lying down - rough movement can upset a cold heart."
            ],
            donts: [
                "Do not use hot baths, heating pads on bare skin, or vigorous rubbing.",
                "Do not give alcohol - it feels warm but speeds heat loss.",
                "Do not assume someone very cold and still is beyond help - continue care until responders arrive."
            ]),
        AidEmergency(
            id: "frostbite", categoryID: "heatcold", title: "Frostbite", art: "aid_frostbite",
            callFirst: false,
            whenToCall: "Seek urgent care for skin that is white, waxy, hard, or numb, and for any blistering after rewarming.",
            steps: [
                "Get the person into a warm shelter and check for hypothermia first - treat that as the priority.",
                "Remove rings, watches, and wet clothing from the affected part before swelling begins.",
                "Warm the area in water at a comfortable warm bath temperature for 20 to 30 minutes - it should feel warm to your own elbow, never hot.",
                "If warm water is unavailable, warm the part against your own body: hands into armpits, for example.",
                "Expect strong burning pain as feeling returns - a pain reliever can help.",
                "After rewarming, wrap loosely in dry gauze, separate fingers and toes with padding, and get medical care."
            ],
            donts: [
                "Do not rub or massage frozen skin, and never rub with snow.",
                "Do not use direct dry heat like fires, stoves, or heating pads - numb skin burns easily.",
                "Do not rewarm a part that could freeze again before reaching care - refreezing is far worse."
            ]),

        // MARK: Bites & Stings
        AidEmergency(
            id: "bee-sting", categoryID: "bites", title: "Bee or Wasp Sting", art: "aid_bee_sting",
            callFirst: false,
            whenToCall: "Call emergency services for any face or throat swelling, trouble breathing, widespread hives, or dizziness - treat as a severe allergic reaction.",
            steps: [
                "If the stinger is still in the skin, scrape it out sideways with a fingernail or card edge as quickly as possible.",
                "Wash the area with soap and water.",
                "Apply a wrapped cold pack for 10 to 15 minutes to ease pain and swelling.",
                "Raise the limb if the sting is on an arm or leg.",
                "An oral antihistamine or a mild steroid cream can calm itching and swelling.",
                "Watch the person for 30 minutes for any signs of a spreading, severe reaction."
            ],
            donts: [
                "Do not squeeze the stinger with tweezers - that injects more venom.",
                "Do not scratch the sting - it worsens swelling and risks infection.",
                "Do not ignore stings inside the mouth or throat - get emergency help."
            ]),
        AidEmergency(
            id: "tick-bite", categoryID: "bites", title: "Tick Bite", art: "aid_tick",
            callFirst: false,
            whenToCall: "See a doctor if you cannot remove the tick fully, a spreading rash appears in the following weeks, or fever and aches develop.",
            steps: [
                "Use fine-tipped tweezers or a tick removal tool - not fingers.",
                "Grip the tick as close to the skin as possible, right at its mouthparts.",
                "Pull straight upward with slow, even pressure. No twisting or jerking.",
                "Clean the bite and your hands with soap and water or an antiseptic.",
                "Note the date and the place on the body where the tick was attached; a photo of the tick can help a doctor.",
                "Watch the area for several weeks for an expanding red ring or flu-like symptoms."
            ],
            donts: [
                "Do not burn the tick, smother it with oil, or coat it in anything - it may release infected fluid.",
                "Do not squeeze its body during removal.",
                "Do not dismiss later fever or rash - mention the bite to your doctor."
            ]),
        AidEmergency(
            id: "animal-bite", categoryID: "bites", title: "Animal or Human Bite", art: "aid_animal_bite",
            callFirst: false,
            whenToCall: "Seek medical care for any bite that breaks the skin - infection risk is high - and urgently for deep wounds, face or hand bites, or unknown animals.",
            steps: [
                "Get to a safe place away from the animal.",
                "Rinse the wound thoroughly under running water for several minutes - this is the key step against infection.",
                "Wash gently with soap around the wound and rinse again.",
                "Control any bleeding with direct pressure and a clean cloth.",
                "Cover with a sterile dressing and seek medical advice about infection, tetanus, and rabies risk.",
                "Report stray or wild animal bites to local authorities if possible."
            ],
            donts: [
                "Do not close a bite wound with tape or tight bandaging - bites need to drain.",
                "Do not ignore small punctures, especially from cats - they infect easily.",
                "Do not handle the animal to check it, even if it seems calm."
            ]),
        AidEmergency(
            id: "snake-bite", categoryID: "bites", title: "Snake Bite", art: "aid_snake",
            callFirst: true,
            whenToCall: "Call emergency services for any bite from a snake that could be venomous - do not wait for symptoms.",
            steps: [
                "Move the person away from the snake and call for emergency help immediately.",
                "Keep the person still and calm - movement spreads venom faster.",
                "Keep the bitten limb still and positioned at or slightly below heart level.",
                "Remove rings, watches, and tight clothing near the bite before swelling starts.",
                "Mark the edge of the swelling on the skin with a pen and note the time - responders use this.",
                "Let the wound bleed freely for a moment, cover with a loose clean dressing, and keep the person warm and still until help arrives."
            ],
            donts: [
                "Do not cut the wound, suck out venom, or apply a tourniquet.",
                "Do not apply ice to a snake bite.",
                "Do not try to catch or kill the snake - a photo from a safe distance is enough."
            ]),

        // MARK: Poisoning & Sugar
        AidEmergency(
            id: "poison-swallowed", categoryID: "poison", title: "Swallowed Poison", art: "aid_poison",
            callFirst: true,
            whenToCall: "Call emergency services or your poison control center immediately for any suspected poisoning - with the container in hand if possible.",
            steps: [
                "Find out what was taken, how much, and when. Keep the container, plant, or packaging.",
                "Call emergency services or poison control right away and follow their instructions exactly.",
                "If there is product around the mouth, wipe it away with a cloth.",
                "If the substance was corrosive and the person is fully alert, a small sip of water to rinse the mouth is fine - spit, not swallow.",
                "If they become drowsy, lie them on their side with the head slightly back, and watch their breathing.",
                "If they stop breathing normally, start CPR - use a face shield or cloth over the mouth if chemicals are involved."
            ],
            donts: [
                "Do not make the person vomit - it can burn the throat a second time.",
                "Do not give milk, salt water, or home antidotes.",
                "Do not wait for symptoms before calling - some poisons act silently."
            ]),
        AidEmergency(
            id: "carbon-monoxide", categoryID: "poison", title: "Carbon Monoxide", art: "aid_co",
            callFirst: true,
            whenToCall: "Call emergency services for headache, dizziness, or nausea affecting several people in the same space, or any collapse near a fuel-burning appliance.",
            steps: [
                "Get everyone out into fresh air immediately - do not stay to search for the source.",
                "Open doors and windows on your way out only if it takes no extra time.",
                "Call emergency services from outside and report suspected carbon monoxide.",
                "Count everyone. Do not go back inside for people or pets - tell responders instead.",
                "Keep affected people resting quietly in fresh air; exertion worsens the poisoning.",
                "If someone is unresponsive and not breathing normally, start CPR in fresh air."
            ],
            donts: [
                "Do not re-enter the building until professionals declare it safe.",
                "Do not treat headache and nausea near an appliance as ordinary illness - suspect the air.",
                "Do not run engines, grills, or generators indoors, ever."
            ]),
        AidEmergency(
            id: "low-sugar", categoryID: "poison", title: "Low Blood Sugar", art: "aid_sugar",
            callFirst: false,
            whenToCall: "Call emergency services if the person becomes unresponsive, cannot swallow safely, or does not improve after two rounds of sugar.",
            steps: [
                "Suspect low sugar in a person with diabetes who is shaky, sweaty, pale, irritable, or confused.",
                "If they are awake and can swallow, give fast sugar: glucose tablets, a small glass of juice or regular soda, or a spoonful of sugar or honey.",
                "Wait 10 to 15 minutes. If they are not clearly better, give the same amount of sugar again.",
                "Once they improve, follow up with a slower snack like bread, crackers, or a sandwich.",
                "Stay with them until they are fully back to normal.",
                "If they become unresponsive, place them on their side, give nothing by mouth, and call emergency services."
            ],
            donts: [
                "Do not give food or drink to someone who is drowsy or unresponsive.",
                "Do not use diet drinks - they contain no sugar.",
                "Do not give insulin - that lowers sugar further."
            ]),
        AidEmergency(
            id: "alcohol", categoryID: "poison", title: "Alcohol Poisoning", art: "aid_alcohol",
            callFirst: true,
            whenToCall: "Call emergency services for confusion, vomiting while drowsy, slow or irregular breathing, cold clammy skin, or a person who cannot be woken.",
            steps: [
                "Try to wake the person. If they respond only weakly or not at all, call for emergency help now.",
                "Roll them onto their side in the recovery position so vomit cannot block the airway.",
                "Tilt the head back slightly to keep the airway open and keep watching their breathing.",
                "Keep them warm with a blanket or coat - alcohol drops body temperature.",
                "If they are awake enough to swallow safely, small sips of water are fine. Nothing else.",
                "Stay with them and check breathing constantly. If it stops being normal, start CPR."
            ],
            donts: [
                "Do not leave them to sleep it off on their back.",
                "Do not give coffee, cold showers, or make them walk - none of it sobers anyone up.",
                "Do not induce vomiting."
            ])
    ]

    // MARK: - CPR steps (own tool screen)

    static let cprSteps: [String] = [
        "Check for danger, then check response: shout and tap their shoulders firmly.",
        "No response? Shout for help, have someone call emergency services and fetch a defibrillator.",
        "Open the airway: tilt the head back, lift the chin. Check breathing for no more than 10 seconds.",
        "Not breathing normally? Start compressions: heel of one hand on the center of the chest, other hand on top.",
        "Push hard and fast: at least 5 cm deep, 100 to 120 pushes per minute. Let the chest rise fully between pushes.",
        "If trained, give 2 rescue breaths after every 30 compressions. If not, keep pushing without stopping.",
        "As soon as a defibrillator arrives, turn it on and follow its voice instructions.",
        "Keep going until the person shows signs of life, a professional takes over, or you are too exhausted."
    ]

    // MARK: - Kits

    static let kits: [AidKit] = [
        AidKit(id: "home", title: "Home Kit", subtitle: "The base kit for every household", art: "kit_home", items: [
            "Adhesive plasters, assorted sizes", "Sterile gauze pads", "Roller bandages", "Elastic bandage",
            "Triangular bandage for slings", "Adhesive tape", "Small sharp scissors", "Fine-tipped tweezers",
            "Disposable gloves, several pairs", "Antiseptic wipes or solution", "Antibiotic ointment",
            "Burn gel or cling film", "Instant cold packs", "Digital thermometer",
            "Pain relievers, adult and child doses", "Oral antihistamine", "Oral rehydration salts",
            "Emergency blanket", "First aid quick-reference card", "List of family medications and allergies"
        ]),
        AidKit(id: "car", title: "Car Kit", subtitle: "Compact kit for the road", art: "kit_car", items: [
            "Warning triangle and reflective vest", "Sterile gauze and pressure dressings", "Roller bandages",
            "Adhesive plasters", "Strong adhesive tape", "Disposable gloves", "Trauma shears",
            "Antiseptic wipes", "Instant cold pack", "Emergency blanket",
            "Flashlight with charged batteries", "Bottled water"
        ]),
        AidKit(id: "travel", title: "Travel Kit", subtitle: "Light kit for trips and hikes", art: "kit_travel", items: [
            "Plasters and blister pads", "Small gauze pads and tape", "Antiseptic wipes",
            "Pain relievers", "Oral antihistamine", "Anti-diarrhea tablets", "Oral rehydration salts",
            "Motion sickness tablets", "Insect repellent", "Sunscreen",
            "Tick removal tool and tweezers", "Personal prescription medicines with copies of prescriptions"
        ])
    ]

    // MARK: - Emergency numbers

    static let numbers: [EmergencyNumber] = [
        EmergencyNumber(region: "United States and Canada", number: "911"),
        EmergencyNumber(region: "European Union", number: "112"),
        EmergencyNumber(region: "United Kingdom", number: "999"),
        EmergencyNumber(region: "Australia", number: "000"),
        EmergencyNumber(region: "New Zealand", number: "111"),
        EmergencyNumber(region: "Japan (ambulance and fire)", number: "119"),
        EmergencyNumber(region: "Japan (police)", number: "110"),
        EmergencyNumber(region: "China (ambulance)", number: "120"),
        EmergencyNumber(region: "India", number: "112"),
        EmergencyNumber(region: "Brazil (ambulance)", number: "192"),
        EmergencyNumber(region: "Mexico", number: "911"),
        EmergencyNumber(region: "South Africa", number: "112"),
        EmergencyNumber(region: "United Arab Emirates", number: "998"),
        EmergencyNumber(region: "Singapore (ambulance)", number: "995"),
        EmergencyNumber(region: "South Korea", number: "119"),
        EmergencyNumber(region: "Turkey", number: "112"),
        EmergencyNumber(region: "Argentina (ambulance)", number: "107"),
        EmergencyNumber(region: "Satellite phones worldwide", number: "112")
    ]

    // MARK: - Quiz

    static let quiz: [AidQuizQuestion] = [
        AidQuizQuestion(id: 1, question: "Blood is soaking through the dressing on a deep cut. What do you do?",
            options: ["Remove it and apply a fresh one", "Add more layers on top and keep pressing", "Rinse the wound again under water"],
            correct: 1, explanation: "Removing the soaked dressing tears away forming clots. Always add layers on top and keep the pressure."),
        AidQuizQuestion(id: 2, question: "How long should you cool a fresh burn under running water?",
            options: ["2 to 3 minutes", "About 20 minutes", "Until it stops hurting"],
            correct: 1, explanation: "A full 20 minutes of cool running water is the single most effective burn treatment."),
        AidQuizQuestion(id: 3, question: "What goes on a fresh burn after cooling?",
            options: ["Butter or a rich cream", "Ice held on the skin", "Cling film or a clean non-fluffy cloth"],
            correct: 2, explanation: "Cling film keeps the burn clean without sticking. Butter and ice both damage the skin further."),
        AidQuizQuestion(id: 4, question: "During a nosebleed, the head should be tilted...",
            options: ["Backward", "Slightly forward", "All the way down between the knees"],
            correct: 1, explanation: "Leaning slightly forward keeps blood from running down the throat, which causes nausea."),
        AidQuizQuestion(id: 5, question: "An adult is choking and cannot make any sound. Your first action?",
            options: ["Up to 5 firm back blows between the shoulder blades", "Abdominal thrusts immediately", "Offer water to wash it down"],
            correct: 0, explanation: "Start with up to 5 back blows, checking the mouth after each, then move to abdominal thrusts."),
        AidQuizQuestion(id: 6, question: "What does the F in FAST stand for when spotting a stroke?",
            options: ["Fever", "Face drooping", "Fatigue"],
            correct: 1, explanation: "FAST: Face drooping, Arm weakness, Speech difficulty, Time to call emergency services."),
        AidQuizQuestion(id: 7, question: "Someone faints. After checking breathing, you should...",
            options: ["Sit them up quickly", "Raise their legs about 30 cm", "Give them a sugary drink right away"],
            correct: 1, explanation: "Raising the legs helps blood return to the brain. Food and drink wait until they are fully alert."),
        AidQuizQuestion(id: 8, question: "During a seizure you should...",
            options: ["Hold the person still", "Put something soft between their teeth", "Clear hard objects away and cushion the head"],
            correct: 2, explanation: "Never restrain a seizing person or put anything in their mouth. Protect the space around them."),
        AidQuizQuestion(id: 9, question: "The right rate for chest compressions in CPR is...",
            options: ["60 to 80 per minute", "100 to 120 per minute", "As fast as physically possible"],
            correct: 1, explanation: "100 to 120 compressions per minute, at least 5 cm deep, letting the chest rise fully between pushes."),
        AidQuizQuestion(id: 10, question: "A wasp stinger is still in the skin. How do you remove it?",
            options: ["Squeeze it out with tweezers", "Scrape it sideways with a card edge", "Leave it - it dissolves"],
            correct: 1, explanation: "Scraping sideways avoids squeezing the venom sac. Tweezers can inject more venom."),
        AidQuizQuestion(id: 11, question: "The correct way to remove a tick is...",
            options: ["Coat it in oil until it lets go", "Burn it off with a match", "Pull straight up slowly with fine tweezers"],
            correct: 2, explanation: "Grip at the skin and pull slowly straight up. Oil and heat make the tick release infected fluid."),
        AidQuizQuestion(id: 12, question: "For a suspected snake bite you should...",
            options: ["Apply a tight tourniquet", "Keep the person still and the limb at heart level", "Suck the venom out quickly"],
            correct: 1, explanation: "Stillness slows venom spread. Cutting, sucking, ice, and tourniquets all make things worse."),
        AidQuizQuestion(id: 13, question: "Someone swallowed a household chemical. You should...",
            options: ["Make them vomit immediately", "Give a big glass of milk", "Call poison control and keep the container"],
            correct: 2, explanation: "Never induce vomiting - corrosives burn twice. Poison control gives exact instructions for the product."),
        AidQuizQuestion(id: 14, question: "Several people in one room have headaches and nausea. Suspect...",
            options: ["Food poisoning", "Carbon monoxide - get everyone to fresh air", "A virus going around"],
            correct: 1, explanation: "Multiple people, same space, same symptoms - suspect carbon monoxide. Get out first, call from outside."),
        AidQuizQuestion(id: 15, question: "A person with diabetes is shaky, sweaty, and confused. Give them...",
            options: ["Their insulin", "Fast sugar like juice or glucose tablets", "A diet soda"],
            correct: 1, explanation: "This looks like low blood sugar. Fast sugar first, then a slower snack. Insulin would lower sugar further."),
        AidQuizQuestion(id: 16, question: "The safest position for an unresponsive person who is breathing is...",
            options: ["Flat on the back", "On their side with head tilted slightly back", "Sitting propped upright"],
            correct: 1, explanation: "The recovery position keeps the airway open and lets fluids drain out instead of blocking the throat."),
        AidQuizQuestion(id: 17, question: "For a sprained ankle, remember RICE:",
            options: ["Rest, Ice, Compression, Elevation", "Run, Ice, Cool, Exercise", "Rest, Iodine, Cast, Elevation"],
            correct: 0, explanation: "Rest the joint, ice 15-20 minutes at a time, wrap with even compression, and keep it elevated."),
        AidQuizQuestion(id: 18, question: "A limb looks bent after a fall. You should...",
            options: ["Gently straighten it before help arrives", "Support it exactly as found", "Test if it can bear weight"],
            correct: 1, explanation: "Never straighten or test a deformed limb. Support it in the position found and keep it still."),
        AidQuizQuestion(id: 19, question: "Warming someone with hypothermia should be...",
            options: ["As fast as possible with a hot bath", "Gradual, with dry layers and warm packs wrapped in cloth", "Done by rubbing the skin vigorously"],
            correct: 1, explanation: "Rapid heat and rough handling endanger a cold heart. Warm gradually: chest, armpits, groin."),
        AidQuizQuestion(id: 20, question: "Frostbitten fingers should never be...",
            options: ["Warmed in comfortably warm water", "Rubbed or massaged", "Padded and wrapped loosely afterward"],
            correct: 1, explanation: "Rubbing frozen tissue grinds ice crystals through the cells. Warm gently in warm water instead."),
        AidQuizQuestion(id: 21, question: "Signs of heatstroke rather than heat exhaustion include...",
            options: ["Heavy sweating and thirst", "Confusion and staggering", "Mild headache after sport"],
            correct: 1, explanation: "Confusion, clumsiness, or collapse in heat means heatstroke - call for help and cool aggressively."),
        AidQuizQuestion(id: 22, question: "During an asthma attack, help the person...",
            options: ["Lie down flat and relax", "Sit upright and use their reliever inhaler", "Breathe into a paper bag"],
            correct: 1, explanation: "Upright posture opens the chest. One puff at a time of their own reliever, following their plan."),
        AidQuizQuestion(id: 23, question: "An epinephrine auto-injector goes into...",
            options: ["The upper arm muscle", "The outer thigh", "The abdomen"],
            correct: 1, explanation: "The outer thigh, and it can go through clothing. Note the time and call emergency services."),
        AidQuizQuestion(id: 24, question: "For a baby under one who is choking, you should never...",
            options: ["Give back blows along your forearm", "Give chest thrusts with two fingers", "Give abdominal thrusts"],
            correct: 2, explanation: "Abdominal thrusts can injure an infant's organs. Use cycles of back blows and chest thrusts."),
        AidQuizQuestion(id: 25, question: "Someone with chest pressure and sweating should...",
            options: ["Walk around to test the pain", "Sit half-upright, stay calm, while you call for help", "Drive to hospital immediately"],
            correct: 1, explanation: "Rest reduces the heart's workload. Call emergency services - never let them drive themselves."),
        AidQuizQuestion(id: 26, question: "After a head bump, a person should be watched for...",
            options: ["Repeated vomiting and worsening confusion", "A small tender lump", "Feeling tired that evening"],
            correct: 0, explanation: "Vomiting, confusion, unequal pupils, or worsening headache are red flags - get emergency care."),
        AidQuizQuestion(id: 27, question: "You find someone in contact with a live electrical cable. First...",
            options: ["Pull them free by the arm quickly", "Cut the power or push the cable away with dry wood", "Pour water to short the circuit"],
            correct: 1, explanation: "Touching them electrocutes you too. Kill the power first, or use something dry and non-conductive."),
        AidQuizQuestion(id: 28, question: "An animal bite that broke the skin should be...",
            options: ["Rinsed under running water for several minutes", "Sealed tightly with tape", "Left open to the air without cleaning"],
            correct: 0, explanation: "Thorough rinsing dramatically cuts infection risk. Then a clean dressing and medical advice.")
    ]
}
