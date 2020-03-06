//
//  TestList.swift
//  YNotes
//
//  Created by Dzhek on 03/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - Notes

let note_1: Note = Note(title: "Сколько текста нужно?",
                        content: "В своём стремлении улучшить пользовательский опыт мы упускаем, что некоторые особенности внутренней политики объединены в целые кластеры себе подобных.",
                        color: .random,
                        importance: .medium,
                        selfDestructionDate: Date())
let note_2: Note = Note(title: "Доблесть наших правозащитников процветает, как ни в чем не бывало",
                        content: "Следует отметить, что новая модель организационной деятельности говорит о возможностях укрепления моральных ценностей.",
                        color: .random,
                        importance: .medium)
let note_3: Note = Note(title: "Может показаться странным, но средства индивидуальной защиты оказались бесполезны",
                        content: "Повышение уровня гражданского сознания напрямую зависит от направлений прогрессивного развития.",
                        color: .random,
                        importance: .low)
let note_4: Note = Note(title: "Да, младая поросль матереет",
                        content: "С другой стороны, высокотехнологичная концепция общественного уклада обеспечивает актуальность системы обучения кадров, соответствующей насущным потребностям.",
                        color: .random,
                        importance: .high)

let note_5: Note = Note(title: "Благородные стремления не спасут: цены на бензин начинают падать",
                        content: "С другой стороны, высокотехнологичная концепция общественного уклада требует анализа приоритизации разума над эмоциями.",
                        color: .random,
                        importance: .high)
let note_6: Note = Note(title: "Только обереги никого не защитили",
                        content: "В своём стремлении повысить качество жизни, они забывают, что курс на социально-ориентированный национальный проект предполагает независимые способы реализации экспериментов, поражающих по своей масштабности и грандиозности.",
                        color: .random,
                        importance: .high,
                        selfDestructionDate: Date())
let note_7: Note = Note(title: "Современная методология разработки бодрит",
                        content: "Учитывая ключевые сценарии поведения, синтетическое тестирование представляет собой интересный эксперимент проверки системы массового участия.",
                        color: .random,
                        importance: .high)
let note_8: Note = Note(title: "Светлый лик – это я",
                        content: "Следует отметить...",
                        color: .random,
                        importance: .high,
                        selfDestructionDate: Date())
let note_9: Note = Note(title: "Средства индивидуальной защиты оказались бесполезны",
                        content: "Учитывая ключевые сценарии поведения, перспективное планирование не даёт нам иного выбора, кроме определения инновационных методов управления процессами.",
                        color: .random,
                        importance: .high)

//MARK: - Initials list

extension FileNotebook {
    
    func initBackendList() {
        if self.notes.count < 1 {
            logDebug("creating a Backend-demo model")
            self.add(note_1)
            self.add(note_2)
            self.add(note_3)
            self.add(note_4)
            self.saveToFile()
            logDebug("Backend-demo model created")
        }
        
    }
    
    func initDatabaseList() {
        if self.notes.count < 1 {
            logDebug("creating a Database-demo model")
            self.add(note_5)
            self.add(note_6)
            self.add(note_7)
            self.add(note_8)
            self.add(note_9)
            self.saveToFile()
            logDebug("Database-demo model created")
        }
    }
}
