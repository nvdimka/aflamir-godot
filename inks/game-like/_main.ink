VAR roll_outcome = true

-> main

EXTERNAL do_roll(skill, dc, debug_val)

=== function do_roll(skill, dc, debug_val) ===
// fallback for testing in Inkle
{ debug_val == true || debug_val == false: 
    ~ roll_outcome = debug_val
}

=== main
Ночь хуечь. Пустыня Афламир. Ваши сапоги тонут в песке.

* [Продолжить идти к огням.] Вы идёте дальше и вдруг пришли.
- 

Горы, башня, лагерь.

- (choices)
* [Притвориться рабом и пробраться в лагерь. #skill.bluff.6]
    ~ do_roll("bluff", 6, true)
    {roll_outcome:
    Вы успешно кродетётсь и входите в кремль.
    -> tower
    - else:
    Вы попадаете в плен. 
    -> cage
    }
* [Вскочить на лошадь и промчаться через лагерь к башне. #skill.force.4]
    ~ do_roll("force", 4, true)
    {roll_outcome:
    Вы успешно проскакиваетете и входите в кремль.
    -> tower
    - else:
    Вы попадаете в плен. 
    -> cage
    }
* [Отыскать тропу в одной из стен каньона. #skill.awareness.4]
    ~ do_roll("awareness", 4, true)
    {roll_outcome:
    Вы успешно нашли тропу.
    -> above_kremlin
    - else:
    Вы попадаете в плен. 
    -> cage
    }
* [Поджечь шатёр маркитанта и, пользуясь суматохой, пройти через лагерь. #skill.awareness.3]
    ~ do_roll("awareness", 4, true)
    {roll_outcome:
    Вы успешно подожгили палатку.
    -> above_kremlin
    - else:
    Вы попадаете в плен. 
    -> cage
    }
* [Бросить Фарианда и сбежать.] Их слишком много. Вы сбегаете в пустыню. -> DONE


=== above_kremlin
wasd

=== tower
Опсаинеие кремля и башни. Подъем наверх.
\---
Сидит Фарианд, нос повесил. Замечает вас. 
ФАРИАНД: Опа нихуя.

* ["Что-нибудь спиздануть".]

=== cage
TODO Разговор с Азисом
-> DONE




-> END
