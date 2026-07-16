import SwiftUI

// MARK: - Severity

enum AidSeverity: Int, Comparable {
    case critical = 0
    case urgent = 1
    case selfCare = 2

    var title: String {
        switch self {
        case .critical: return "Life-threatening"
        case .urgent: return "Get medical help"
        case .selfCare: return "Self-care"
        }
    }

    var tint: Color {
        switch self {
        case .critical: return AidTheme.primary
        case .urgent: return AidTheme.amber
        case .selfCare: return AidTheme.sage
        }
    }

    var soft: Color {
        switch self {
        case .critical: return AidTheme.peach
        case .urgent: return AidTheme.amberSoft
        case .selfCare: return AidTheme.sageSoft
        }
    }

    static func < (lhs: AidSeverity, rhs: AidSeverity) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension AidEmergency {
    var severity: AidSeverity {
        AidContentPlus.severityMap[id] ?? .urgent
    }

    var aftercare: [String] {
        AidContentPlus.aftercareMap[id] ?? []
    }
}

// MARK: - Myths

struct AidMyth: Identifiable {
    let id: Int
    let statement: String
    let isTrue: Bool
    let verdict: String
}

// MARK: - Extra content

enum AidContentPlus {

    static let severityMap: [String: AidSeverity] = [
        "severe-bleeding": .critical, "cuts-scrapes": .selfCare, "nosebleed": .selfCare, "splinter": .selfCare,
        "thermal-burn": .urgent, "chemical-burn": .critical, "electrical-burn": .critical, "sunburn": .selfCare,
        "choking-adult": .critical, "choking-infant": .critical, "asthma": .urgent, "anaphylaxis": .critical,
        "heart-attack": .critical, "stroke": .critical, "fainting": .urgent, "seizure": .urgent,
        "sprain": .selfCare, "fracture": .urgent, "head-injury": .urgent, "spinal": .critical,
        "heatstroke": .critical, "heat-exhaustion": .urgent, "hypothermia": .critical, "frostbite": .urgent,
        "bee-sting": .selfCare, "tick-bite": .selfCare, "animal-bite": .urgent, "snake-bite": .critical,
        "poison-swallowed": .critical, "carbon-monoxide": .critical, "low-sugar": .urgent, "alcohol": .critical
    ]

    static let aftercareMap: [String: [String]] = [
        "severe-bleeding": [
            "Keep the dressing in place until professionals take over - even a well-meaning peek restarts bleeding.",
            "Watch for shock while you wait: pale clammy skin, fast breathing, drowsiness.",
            "Any wound that needed this much pressure needs stitches and a tetanus check."
        ],
        "cuts-scrapes": [
            "Keep the wound clean and dry for the first day, then wash gently around it daily.",
            "A little redness at the edges is normal; spreading redness, warmth, or pus is not.",
            "If you have not had a tetanus booster in 10 years and the cut was dirty, ask your doctor."
        ],
        "nosebleed": [
            "No nose blowing, picking, or heavy lifting for the rest of the day.",
            "Sleep with the head slightly raised the first night.",
            "Frequent nosebleeds are worth mentioning to a doctor - especially on blood thinners."
        ],
        "splinter": [
            "Keep a plaster on for a day and check the spot when you change it.",
            "Throbbing, spreading redness, or a visible dark fragment left inside means a doctor visit.",
            "Deep wood or organic splinters carry higher infection risk than metal or glass."
        ],
        "thermal-burn": [
            "Keep the burn covered, loose, and clean; change the dressing daily.",
            "Blisters that form are sterile bandages made by your body - leave them intact.",
            "See a doctor if the burn is not clearly healing within two weeks or looks infected."
        ],
        "chemical-burn": [
            "Bring the chemical name or container to every medical appointment about the burn.",
            "Some chemicals keep damaging tissue for hours - follow up even if it looks mild.",
            "Photograph the burn daily; worsening after day one needs review."
        ],
        "electrical-burn": [
            "Insist on a medical check even without visible marks - the damage travels inside.",
            "Report any palpitations, dizziness, or numbness in the following days immediately.",
            "Have an electrician fix whatever caused the shock before anyone touches it again."
        ],
        "sunburn": [
            "Moisturize twice daily while the skin heals and drink extra water.",
            "Peeling skin is healing skin - do not pull it off.",
            "Repeated burning permanently raises skin cancer risk; check moles yearly."
        ],
        "choking-adult": [
            "Anyone who received abdominal thrusts should be checked by a doctor - they can bruise organs.",
            "Coughing, wheezing, or throat pain that persists afterward needs medical review.",
            "Cut food smaller and sit upright while eating if this keeps happening."
        ],
        "choking-infant": [
            "Have the baby checked by a doctor after any real choking episode, even a resolved one.",
            "Keep small objects, grapes, nuts, and hard candy away from children under four.",
            "A first aid course for parents pays for itself in confidence alone."
        ],
        "asthma": [
            "Log the attack and its trigger in the person's asthma plan or notes.",
            "A reliever used more than twice a week means the treatment plan needs review.",
            "Replace inhalers before they expire and keep a spare at home and at work."
        ],
        "anaphylaxis": [
            "Anyone who used epinephrine must still go to hospital - symptoms can return within hours.",
            "Replace the used auto-injector immediately and check the expiry of the spare.",
            "An allergist can pin down the trigger and update the emergency plan."
        ],
        "heart-attack": [
            "Cardiac rehab and medication adherence cut the risk of a second event dramatically.",
            "Note the exact symptoms that happened - they are often the same the next time.",
            "Family members should learn CPR; most cardiac arrests happen at home."
        ],
        "stroke": [
            "Recovery starts fast: therapy in the first weeks matters most - attend everything.",
            "Note the exact time symptoms started and share it with every clinician.",
            "Blood pressure control is the single biggest protector against another stroke."
        ],
        "fainting": [
            "Eat, drink, and rest before returning to normal activity.",
            "Note what happened just before - standing up fast, heat, pain, or fear are common triggers.",
            "Fainting with no clear trigger, or during exercise, always deserves a medical check."
        ],
        "seizure": [
            "Let the person rest; confusion and exhaustion afterward are normal for a while.",
            "Write down how long it lasted and what it looked like - invaluable for doctors.",
            "A first-ever seizure always needs a medical workup, even after full recovery."
        ],
        "sprain": [
            "Keep compression on during the day for the first two days, off at night.",
            "Start gentle circles and stretches once pain allows - joints heal with movement.",
            "If it is not clearly better after a week, get it examined."
        ],
        "fracture": [
            "Follow the cast or splint instructions exactly - wet or loose casts fail quietly.",
            "Growing pain, numbness, or blue fingers and toes under a cast is an emergency.",
            "Ask about rehab exercises; muscles shrink fast in plaster."
        ],
        "head-injury": [
            "Take it easy for at least 24 to 48 hours: no sport, no alcohol, limited screens.",
            "Have someone check on the person during the first night.",
            "Worsening headache, repeated vomiting, or confusion any time later - go to emergency care."
        ],
        "spinal": [
            "There is no home aftercare for a suspected spinal injury - it is hospital territory.",
            "If cleared by doctors, follow their activity restrictions to the letter.",
            "Persistent tingling or weakness after any back injury needs urgent review."
        ],
        "heatstroke": [
            "Full recovery takes days - no heat, sport, or alcohol until a doctor clears it.",
            "The person remains extra sensitive to heat for weeks afterward.",
            "Review what led to it: exertion, medications, and dehydration are the usual suspects."
        ],
        "heat-exhaustion": [
            "Rest in the cool for the remainder of the day, keep drinking steadily.",
            "Headache or fatigue may linger into the next day - that is normal.",
            "Returning to heat too soon is the fast lane to heatstroke."
        ],
        "hypothermia": [
            "Warm drinks, dry clothes, and rest for the remainder of the day.",
            "Watch for confusion or drowsiness returning - rewarming can be uneven.",
            "The very young and elderly should be medically checked after any real hypothermia."
        ],
        "frostbite": [
            "Blisters after rewarming are expected - cover them, never pop them.",
            "The area stays cold-sensitive, sometimes for years; protect it well.",
            "Any blackening or numbness that persists needs a doctor promptly."
        ],
        "bee-sting": [
            "Itching and a small swollen patch can last a couple of days - cold packs help.",
            "Swelling that keeps growing after 48 hours may be infected.",
            "A large local reaction is worth mentioning to a doctor; it can predict stronger ones."
        ],
        "tick-bite": [
            "Mark the date on a calendar and watch the site for about four weeks.",
            "An expanding red ring or flu-like feeling anytime in the next month - see a doctor and mention the bite.",
            "Check the whole body after every walk in grass or woods; ticks pick warm creases."
        ],
        "animal-bite": [
            "Watch for infection daily: bites infect more often than any other small wound.",
            "Complete the full course of any antibiotics prescribed.",
            "If the animal cannot be observed, take rabies advice seriously - it is not optional."
        ],
        "snake-bite": [
            "Hospital observation matters even if symptoms seem mild at first.",
            "Keep the limb rested and follow up on wound care after discharge.",
            "Wear boots and stick to paths in snake country; most bites are on ankles and hands."
        ],
        "poison-swallowed": [
            "Save the container and any remaining substance for the medical team.",
            "Follow poison control's follow-up instructions exactly, even if symptoms fade.",
            "Move all chemicals and medicines out of children's reach - today."
        ],
        "carbon-monoxide": [
            "Nobody re-enters until the source is found and fixed by a professional.",
            "Install or test CO alarms on every level of the home.",
            "Headaches that return in the same room or house are a red flag, not a coincidence."
        ],
        "low-sugar": [
            "Eat a proper meal within an hour of recovery to prevent a second dip.",
            "Log the episode: time, what preceded it, and how much sugar it took.",
            "Frequent lows mean the diabetes plan needs adjusting - book a review."
        ],
        "alcohol": [
            "Stay with them until they can walk and talk normally; recovery position for any sleep.",
            "The next day, encourage fluids and food - and a frank look at what happened.",
            "Repeated episodes are a health emergency in slow motion; help them seek support."
        ]
    ]

    // MARK: - Kit item explanations (keyed by exact item text)

    static let kitWhys: [String: String] = [
        "Adhesive plasters, assorted sizes": "The workhorse for everyday cuts - assorted sizes mean fingers, knees, and knuckles are all covered.",
        "Sterile gauze pads": "The right way to press on a bleeding wound and the base layer of most dressings.",
        "Roller bandages": "Hold dressings in place and provide pressure over larger wounds.",
        "Elastic bandage": "Compression for sprains and strains - the C in RICE.",
        "Triangular bandage for slings": "Supports an injured arm or shoulder; doubles as a big dressing or tie.",
        "Adhesive tape": "Secures gauze and dressings where plasters will not reach.",
        "Small sharp scissors": "Cutting tape, gauze, and clothing away from an injury.",
        "Fine-tipped tweezers": "Splinters and ticks - the two jobs fingers are worst at.",
        "Disposable gloves, several pairs": "Protects both of you whenever blood or fluids are involved.",
        "Antiseptic wipes or solution": "Cleans the skin around wounds when soap and water are not available.",
        "Antibiotic ointment": "A thin layer on minor cuts lowers infection risk and keeps dressings from sticking.",
        "Burn gel or cling film": "After cooling, a burn needs a clean non-stick cover - cling film is ideal.",
        "Instant cold packs": "Cold on demand for sprains, bumps, and stings - no freezer required.",
        "Digital thermometer": "Turns 'feels hot' into a number you can act on and report.",
        "Pain relievers, adult and child doses": "Pain and fever control; child doses belong in every family kit.",
        "Oral antihistamine": "Calms allergic reactions, stings, and itchy rashes.",
        "Oral rehydration salts": "Restores fluids properly after vomiting, diarrhea, or heat exhaustion.",
        "Emergency blanket": "Compact foil that holds body heat for shock and hypothermia.",
        "First aid quick-reference card": "Under stress, memory fails - a printed cheat sheet does not.",
        "List of family medications and allergies": "The first thing paramedics ask; write it once, update it yearly.",
        "Warning triangle and reflective vest": "Being visible is your first aid at a roadside - protect the scene before the person.",
        "Sterile gauze and pressure dressings": "Road injuries bleed; pressure dressings are built exactly for that.",
        "Adhesive plasters": "Small cuts happen on every trip - cover them before dirt finds them.",
        "Strong adhesive tape": "Fixes dressings, splints, and half of everything else.",
        "Disposable gloves": "Helping strangers means gloves on, always.",
        "Trauma shears": "Cuts through seat belts and clothing fast and safely.",
        "Antiseptic wipes": "Clean hands and skin when there is no water for miles.",
        "Instant cold pack": "Swelling control for sprains and bumps far from a freezer.",
        "Flashlight with charged batteries": "Breakdowns and injuries prefer the dark; check the batteries twice a year.",
        "Bottled water": "Rinsing wounds, cooling burns, and drinking - the most versatile item in the car.",
        "Plasters and blister pads": "Blisters end more hikes than injuries do - pad them early.",
        "Small gauze pads and tape": "A compact wound kit that weighs nothing.",
        "Pain relievers": "Headaches and sore muscles should not decide your itinerary.",
        "Anti-diarrhea tablets": "Buys you safe time when traveler's stomach strikes far from help.",
        "Motion sickness tablets": "Winding roads and boat rides go much better taken in advance.",
        "Insect repellent": "Preventing bites beats treating them - especially where ticks and mosquitoes carry disease.",
        "Sunscreen": "The cheapest skin cancer prevention ever invented; reapply every two hours.",
        "Tick removal tool and tweezers": "Ticks come off best with the right tool within hours of attaching.",
        "Personal prescription medicines with copies of prescriptions": "Your own medicines are the one thing no pharmacy abroad can reliably replace."
    ]

    // MARK: - Myths (16)

    static let myths: [AidMyth] = [
        AidMyth(id: 1, statement: "Put butter on a burn to soothe it.", isTrue: false,
                verdict: "Butter seals heat in and feeds bacteria. Cool running water for 20 minutes is the only right answer."),
        AidMyth(id: 2, statement: "Tilt the head back to stop a nosebleed.", isTrue: false,
                verdict: "Backward means blood down the throat: nausea and vomiting. Lean forward and pinch the soft part for 10 minutes."),
        AidMyth(id: 3, statement: "Suck the venom out of a snake bite.", isTrue: false,
                verdict: "Sucking removes almost nothing and adds mouth bacteria to the wound. Keep the person still and get help."),
        AidMyth(id: 4, statement: "You should put something in a seizing person's mouth so they do not swallow their tongue.", isTrue: false,
                verdict: "Swallowing the tongue is anatomically impossible, and objects in the mouth break teeth. Protect the space around them instead."),
        AidMyth(id: 5, statement: "A drowning person waves and shouts for help.", isTrue: false,
                verdict: "Real drowning is quiet and fast - the mouth is busy trying to breathe. Watch for vertical, silent struggling."),
        AidMyth(id: 6, statement: "Cool a burn under running water for a full 20 minutes.", isTrue: true,
                verdict: "True - and it works even if started up to an hour after the injury. It is the single most effective burn treatment."),
        AidMyth(id: 7, statement: "Rub frostbitten hands with snow to warm them up.", isTrue: false,
                verdict: "Rubbing grinds ice crystals through frozen cells. Rewarm gently in comfortably warm water instead."),
        AidMyth(id: 8, statement: "Coffee sobers up a drunk person.", isTrue: false,
                verdict: "Caffeine makes an impaired person feel more awake while just as impaired - and wastes time when they may need real help."),
        AidMyth(id: 9, statement: "Chest compressions alone, without rescue breaths, are still worthwhile CPR.", isTrue: true,
                verdict: "True. Hands-only CPR keeps blood moving and is what dispatchers coach untrained helpers to do."),
        AidMyth(id: 10, statement: "Make a poisoned person vomit as fast as possible.", isTrue: false,
                verdict: "Corrosives burn a second time on the way up. Call poison control - they know what the specific substance needs."),
        AidMyth(id: 11, statement: "Pee on a jellyfish sting to neutralize it.", isTrue: false,
                verdict: "Urine can trigger more venom release. Rinse with seawater, remove tentacles with tweezers, then hot water for the pain."),
        AidMyth(id: 12, statement: "A person having a heart attack always clutches their chest dramatically.", isTrue: false,
                verdict: "Many heart attacks are quiet: pressure, nausea, sweating, jaw or back pain - especially in women and people with diabetes."),
        AidMyth(id: 13, statement: "Scrape a bee stinger out sideways instead of pulling it with tweezers.", isTrue: true,
                verdict: "True. Squeezing the sac with tweezers injects more venom; scraping with a card edge avoids it."),
        AidMyth(id: 14, statement: "Warm the core of a hypothermic person, not the hands and feet first.", isTrue: true,
                verdict: "True. Chest, armpits, and groin come first - warming limbs first pushes cold blood to the heart."),
        AidMyth(id: 15, statement: "If someone can cough, you should slap their back right away.", isTrue: false,
                verdict: "A strong cough is the most effective tool there is - encourage it. Back blows are for when coughing fails."),
        AidMyth(id: 16, statement: "Ice directly on the skin cools an injury best.", isTrue: false,
                verdict: "Bare ice causes frost injury on top of the sprain. Always wrap cold packs in a thin cloth, 15-20 minutes at a time.")
    ]

    // MARK: - Extra quiz questions (42 total with base 28)

    static let extraQuiz: [AidQuizQuestion] = [
        AidQuizQuestion(id: 29, question: "How long should you pinch the nose for a nosebleed before checking?",
            options: ["2 minutes", "A full 10 minutes", "30 seconds at a time"],
            correct: 1, explanation: "Ten uninterrupted minutes lets a clot form. Peeking early tears it loose again."),
        AidQuizQuestion(id: 30, question: "A tooth gets knocked out. The best transport medium is...",
            options: ["A dry tissue", "Milk, or the person's own saliva", "Hot water"],
            correct: 1, explanation: "Keep the root moist in milk or saliva and see a dentist within the hour - reimplantation can work."),
        AidQuizQuestion(id: 31, question: "The recovery position is used for someone who is...",
            options: ["Unresponsive but breathing normally", "Awake with chest pain", "Having a seizure right now"],
            correct: 0, explanation: "On the side, head back: the airway stays open and fluids drain out. Never for someone actively seizing."),
        AidQuizQuestion(id: 32, question: "How deep should adult chest compressions be?",
            options: ["2 to 3 cm", "At least 5 cm", "As deep as possible regardless of recoil"],
            correct: 1, explanation: "At least 5 cm, letting the chest fully rise between pushes - the recoil refills the heart."),
        AidQuizQuestion(id: 33, question: "Clothing is stuck to a fresh burn. You should...",
            options: ["Peel it off quickly", "Cut around it and leave the stuck part", "Soak it in ointment first"],
            correct: 1, explanation: "Pulling stuck fabric tears the burned skin. Cool through it and let professionals remove it."),
        AidQuizQuestion(id: 34, question: "Someone is hyperventilating during a panic episode. Help them...",
            options: ["Breathe into a paper bag immediately", "Slow their breathing: in through the nose, long exhale", "Lie flat and hold their breath"],
            correct: 1, explanation: "Slow coached breathing works and is safe; paper bags are risky if the real cause is not panic."),
        AidQuizQuestion(id: 35, question: "A blister from a hike should be...",
            options: ["Popped with a clean needle right away", "Left intact and padded", "Rubbed to toughen the skin"],
            correct: 1, explanation: "Intact skin is a sterile dressing. Pad around it; only drain if it will clearly burst on its own."),
        AidQuizQuestion(id: 36, question: "What does an AED (defibrillator) do when you turn it on?",
            options: ["Nothing until a doctor arrives", "Speaks instructions aloud and only shocks if needed", "Shocks immediately"],
            correct: 1, explanation: "AEDs are built for untrained users: voice-guided, and they analyze the rhythm before allowing any shock."),
        AidQuizQuestion(id: 37, question: "Something is splashed in the eye. Rinse...",
            options: ["From the outer corner toward the nose", "From the nose outward, water running away from the other eye", "Only if it stings"],
            correct: 1, explanation: "Nose outward keeps the chemical from washing into the unaffected eye. Rinse long - 20 minutes for chemicals."),
        AidQuizQuestion(id: 38, question: "The safest way to help someone stuck to an electrical source is...",
            options: ["Grab their clothes and pull", "Kill the power, or use dry wood to push the source away", "Throw water on the contact point"],
            correct: 1, explanation: "You cannot help anyone while being shocked yourself. Power off first, always."),
        AidQuizQuestion(id: 39, question: "Bleeding from a nose after a serious head impact...",
            options: ["Is treated like any nosebleed", "Can signal a skull injury - get emergency care", "Means nothing if it stops"],
            correct: 1, explanation: "Blood or clear fluid from the nose or ears after head trauma is a red flag for skull fracture."),
        AidQuizQuestion(id: 40, question: "A diabetic friend is unconscious. You should...",
            options: ["Rub honey inside their cheek anyway", "Give nothing by mouth, recovery position, call for help", "Give them their insulin"],
            correct: 1, explanation: "Anything by mouth can choke an unconscious person. Side position, emergency call, nothing to swallow."),
        AidQuizQuestion(id: 41, question: "How often should you check and refresh a first aid kit?",
            options: ["Only when something runs out", "Twice a year, checking expiry dates", "Every five years"],
            correct: 1, explanation: "Twice a year catches expired medicines, dried-out wipes, and used-up plasters before you need them."),
        AidQuizQuestion(id: 42, question: "Someone faint says they feel better after 30 seconds and wants to jump up.",
            options: ["Let them - fainting is over when it is over", "Keep them down a few minutes, then rise in stages", "Give them coffee to stabilize"],
            correct: 1, explanation: "Standing too fast is how one faint becomes two. Legs down, sit, pause, then stand.")
    ]

    static var allQuiz: [AidQuizQuestion] {
        AidContent.quiz + extraQuiz
    }

    // MARK: - Featured guide of the day

    static func featuredEmergency(for date: Date = Date()) -> AidEmergency {
        let day = Calendar.current.ordinality(of: .day, in: .era, for: date) ?? 0
        let list = AidContent.emergencies
        return list[day % list.count]
    }

    static let quickAccessIDs = ["choking-adult", "severe-bleeding", "heart-attack", "stroke"]
}
