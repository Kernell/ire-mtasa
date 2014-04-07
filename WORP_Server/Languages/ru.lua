-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

TEXT_SERVER_NAME	= "Multi Theft Auto ROLEPLAY";

TEXT_EMAIL_NO_REPLY				= "no-reply@mtaroleplay.ru";
TEXT_EMAIL_ACTIVATION_SUBJECT	= "Активация аккаунта - Multi Theft Auto ROLEPLAY";

TEXT_REG_UNAVAILABLE = "Извините, регистрация в данный момент отключена";

TEXT_REG_RULES = 
[[
На данный момент сервер находится в стадии бета-тестирования

Наш сайт: http://mtaroleplay.ru/
Баг-трекер: http://bugs.mtaroleplay.ru/
]]

TEXT_HELP_WEAPON_BINDS			=
[[
R - Перезарядить текущее оружие
0 - Выбросить текущее оружие
1 - Слот оружия 1 (Автоматы)
2 - Слот оружия 2 (Пистолеты)
3 - Слот оружия 3 (Холодное оружие, дубинки и т.д.)
4 - Слот оружия 4 (Гранаты)
5 - Слот оружия 5 (Очки ночного виденья, инфракрасные очки, парашют)
]]

TEXT_HELP_CAR_BINDS				=
[[
J - Завести/заглушить двигатель
K - Открыть/закрыть двери
L - Включить/выключить фары
< и > - Поворотники
]]

TEXT_HELP_POLICE_CAR_BINDS		= 
[[
N - Проблесковые маячки
H - Тип проблесковых маячков
Z - Сирена
X - Тип сирены
]]

TEXT_HELP_COMMANDS_MAIN		=
[[
eject <player>
    —— выкидывает из машины игрока, либо * чтобы выкинуть всех

changespawn
    —— изменение респавна персонажа

report <text>
    —— отправить сообщение администраторам. Не разрешено использовать для вопросов по игровому процессу.

view_help
    —— отображает окно помощи (F1)
	
stats
    —— статистика персонажа (F2)
	
weapon_slot <slot>
    —— достаёт/убирает оружие из слота (по умолчанию назначены на клавиши 1, 2, 3 и  4)
	
pay <player> <value>
    —— используется для передачи денег
	
reload_weapon
    —— перезаряжает текущие оружие в руках (клавиша R по умолчанию)
	
drop_weapon
    —— выбрасывает текущее оружие в руках (клавиша 0 по умолчанию)

GlobalOOC, o <text>
    —— глобальный ООС чат

LocalOOC, b <text>
    —— локальный ООС чат

c <text>
    —— IC шепот

shout, s <text>
    —— IC крик

me <action>
    —— описание действий вашего персонажа
	
do <action>
    —— описание действий происходящие вокруг персонажа

try <action>
    —— попытка воспроизвести действие вашего персонажа (случайно)

dice
    —— бросить игральные кости

coin
    —— бросить монетку (орёл/решка)

]]

TEXT_HELP_COMMANDS_ADD	=
[[
race
    —— команды для работы с трассами гонок. Введите race --help для большей информации
]]

TEXT_HELP_RULES		= 
[[ Общие правила сервера

1. Установка дополнительных модулей или другого программного обеспечения на машину игрока или изменение ее настроек, использование неявных или недокументированных особенностей игры или ее окружения, с целью получения явного или неявного преимущества в различных фазах игры, является нарушением правил игры и приравнивается к использованию читов.

2. Если Вы нашли баг - сообщите о нём администратору. Использование багов игрового режима приравнивается к использованию читов.

3. Запрещается использование различных модификаций 3D моделей игры кроме тех, что устанавливает сам сервер.

4. Запрещается использование ников администраторов, как часть другого ника.

5. Запрещается использование заведомо похожие имена игроков, а также заведомо чужие ники.

6. Запрещается использование сообщений состоящих из заглавных символов (Caps Lock).

7. Запрещается использование любой нецензурной лексики в ООС чатах – будь то мат, грубое выражение, завуалированный мат, сокращение мата.

8. Запрещается вмешиваться в работу администрации. Если Вам нужна помощь администратора, используйте кнопку Support или команду /report.
]]

TEXT_HELP_JOBS		= 
[[
Данный раздел ещё в разработке
]]

TEXT_HELP_BINDS		= 
[[
Общее:
F1 - Справка
F2 - Статистика персонажа
F3 - Управление текущей фракцией
F5 - Меню фракции
F7 - Анимации
B - Локальный OOC чат
O - Глобальный OOC чат
M - Включение/выключение курсора мыши

Оружие:
]] + TEXT_HELP_WEAPON_BINDS + [[

Транспорт:
]] + TEXT_HELP_CAR_BINDS + [[

Полицейский автомобиль:
]] + TEXT_HELP_POLICE_CAR_BINDS


TEXT_E2251					= "Cannot find default constructor to initialize base class '%s'"
TEXT_E2288					= "Pointer to structure required on left side of -> or ->*"
TEXT_E2315					= "'%s' is not a member of '%s', because the type is not yet defined"
TEXT_E2342					= "Type mismatch in parameter '%s' (wanted '%s', got '%s')"
TEXT_E2451					= "Undefined symbol '%s'"
TEXT_W8105					= "%s member '%s' in class without constructors"
TEXT_W8106					= "%s are deprecated"
TEXT_DB_ERROR				= "Ошибка при работе с базой данных"
TEXT_NOT_ENOUGH_MEMORY 		= "Недостаточно памяти"

TEXT_NOT_ENOUGH_MONEY			= "У Вас недостаточно денег"
TEXT_ACCESS_DENIED				= "У Вас нет прав на совершение этого действия"
TEXT_FEATURE_IN_DEVELOPMENT		= "Эта функция пока ещё в разработке"
TEXT_NOT_ALLOWED_FOR_ADMINS		= "Эта функция недоступна для администраторов"
TEXT_NOT_ALLOWED_IN_ADMINDUTY	= "Эта функция недоступна в режиме администратора"

TEXT_PLAYER_NOT_FOUND			= "Игрок не найден"
TEXT_PLAYER_NOT_LOGGED			= "Игрок не авторизован"
TEXT_PLAYER_NOT_IN_GAME			= "Игрок не в игре"
TEXT_PLAYER_NOT_NEARBY			= "Игрок слишком далеко"
TEXT_PLAYER_HAS_IMMUNITY		= "Этот игрок имеет иммунитет"
TEXT_PLAYER_INVALID_NAME		= "Некорректное имя"
TEXT_PLAYER_NAME_ALREADY_IN_USE	= "Это имя уже занято"
TEXT_PLAYER_NAME_CHANGE_FAILED	= "Ошибка при изменении имени"
TEXT_PLAYER_NAME_CHANGED		= "Вы сменили ник игроку %s (%d) на новый %q"
TEXT_PLAYER_NAME_CHANGED2		= "%s сменил Вам ник %q на %q"
TEXT_PLAYER_NAME_CHANGED_A		= "Администратор %s сменил ник игроку %s на %q";
TEXT_PLAYER_INVALID_SKIN		= "Некорректный скин"
TEXT_PLAYER_INVALID_WEAPON		= "Некорректное оружие %q"
TEXT_PLAYER_SKIN_CHANGED		= "%s сменил Вам скин (Skin ID: %d Name: %q)"
TEXT_PLAYER_RECONNECTED			= "Отправлена команда на переподключение к серверу игроку %s (%d)"
TEXT_PLAYER_SET_MONEY			= "У игрока %s (%d) теперь $%d"
TEXT_PLAYER_GIVE_MONEY			= "Вы дали игроку %s (%d) $%d"
TEXT_PLAYER_FACTION_CHANGED		= "Вы установили игроку %s (%d) фракцию %s (уровень прав: %s, ранк: %s (%d))"
TEXT_PLAYER_FACTION_CHANGED2	= "%s установил Вам фракцию %s (уровень прав: %s, ранк: %s (%d))"
TEXT_PLAYER_FACTION_REMOVED		= "Игрок %s (%d) теперь больше не состоит во фракции"
TEXT_PLAYER_FACTION_REMOVED2	= "%s выгнал Вас из фракции"

TEXT_NPC_NOT_FOUND				= "NPC не найден"
TEXT_NPC_NOT_FOUND_ID			= "NPC ID %d не найден"
TEXT_NPC_CREATED				= "NPC успешно создан, ID: %d"
TEXT_NPC_INVALID_MODEL			= "Некорректная модель"
TEXT_NPC_REMOVED				= "NPC ID %d успешно удалён"
TEXT_NPC_REMOVE_FAILED			= "Ошибка при удалении NPC ID %d"
TEXT_NPC_POSITION_UPDATED		= "Позиция NPC ID %d успешно обновлена %s %.3f"
TEXT_NPC_ANIMATION_UPDATED		= "Анимация NPC ID %d успешно обновлена"
TEXT_NPC_INTERACTIVE_COMMAND_UPDATED	= "Интерактивное действие для NPC ID %d установлено на %q"
TEXT_NPC_FROZEN					= "NPC ID %d успешно заморожен"
TEXT_NPC_UNFROZEN				= "NPC ID %d успешно разморожен"
TEXT_NPC_DAMAGE_PROOF_ENABLED	= "Повреждения для NPC ID %d выключены"
TEXT_NPC_DAMAGE_PROOF_DISABLED	= "Повреждения для NPC ID %d включены"
TEXT_NPC_COLLISIONS_ENABLED		= "Коллизия для NPC ID %d успешно включена"
TEXT_NPC_COLLISIONS_DISABLED	= "Коллизия для NPC ID %d успешно выключена"

TEXT_INTERIORS_INVALID_ID		= "Ошибка: Интерьер с таким ID не найден"
TEXT_INTERIORS_INVALID_INTERIOR	= "Ошибка: Неизвестный интерьер"
TEXT_INTERIORS_INVALID_TYPE		= "Ошибка: Не верный тип интерьера"
TEXT_INTERIORS_CREATION_SUCCESS	= "Интерьер '%s' успешно создан, ID: %d"
TEXT_INTERIORS_CREATION_FAIL	= "Ошибка: Не удалось получить идентификатор. Обратитесь к системному администратору"
TEXT_INTERIORS_REMOVE_SUCCESS	= "Интерьер '%s' (%d) успешно удалён"
TEXT_INTERIORS_TYPE_CHANGED		= "Тип интерьера '%s' (%d) успешно изменён на '%s'"
TEXT_INTERIORS_NAME_CHANGED		= "Название интерьера '%s' (%d) успешно изменено на '%s'"
TEXT_INTERIORS_PRICE_CHANGED	= "Цена интерьера '%s' (%d) успешно изменена на $%d"
TEXT_INTERIORS_BANK_CHANGED		= "Банк интерьера '%s' (%d) успешно изменён на $%d"
TEXT_INTERIORS_LOCKED_CHANGED	= "Интерьер '%s' (%d) теперь %s"
TEXT_INTERIORS_DROPOFF_CHANGED	= "Dropoff for interior '%s' (%d) changed to %f, %f, %f"
TEXT_INTERIORS_YOU_ARE_NOT_IN_INTERIOR	= "Вы должны быть в интерьере"
TEXT_INTERIORS_INT_CHANGED		= "Интерьер '%s' (%d) успешно изменён на '%s'"
TEXT_INTERIORS_OWNER_CHANGED	= "Владелец интерьера %q (%d) теперь %s"
TEXT_INTERIORS_FACTION_CHANGED	= "Интерьер %q (%d) теперь принадлежит организации %q"

TEXT_INTERIORS_BOUGHT			= "Эта собственность теперь Ваша!\n\nЧтобы открыть меню интерьера нажмите клавишу 'X'"
TEXT_INTERIORS_CORRUPT			= "Этот интерьер повреждён.\n\nОбратитесь к системному администратору"

TEXT_MAPS_INVALID_NAME			= "Карта с именем %q не существует"
TEXT_MAPS_MAP_ALREADY_ADDED		= "Карта с именем %q уже добавлена"
TEXT_MAPS_MAP_HAS_NO_OBJECTS	= "Карта %q не содержит объектов"
TEXT_MAPS_ADD_SUCESS			= "Карта %q успешно добавлена (%d из %d объектов добавлено, проигнорировано элементов: %d)"
TEXT_MAPS_ADD_FAILED			= "Невозможно добавить карту %q"
TEXT_MAPS_UNABLE_LOAD_OBJECTS	= "Невозможно добавить объекты в карту %q"
TEXT_MAPS_REMOVE_SUCCESS		= "Карта %q успешно удалена"
TEXT_MAPS_REMOVE_FAILED			= "Невозможно удалить карту %q"
TEXT_MAPS_IS_PROTECTED			= "Карта %q защищена"
TEXT_MAPS_DIMENSION_CHANGED		= "Измерение для карты %q изменено на %d"

TEXT_TELEPORTS_INVALID_ID		= "Маркера с таким ID не существует"
TEXT_TELEPORTS_CREATE_SUCCESS	= "Маркер ID:%d создан"
TEXT_TELEPORTS_REMOVE_SUCCESS	= "Маркер ID:%d успешно удалён"
TEXT_TELEPORTS_FACTION_CHANGED	= "Фракция для маркера ID:%d успешно изменена на %s (%d)"

TEXT_VEHICLES_INVALID_ID		= "Автомобиля с таким ID не существует"
TEXT_VEHICLES_INVALID_DB_ID		= "Автомобиля с таким ID в базе данных не существует"
TEXT_VEHICLES_REMOVE_SUCCESS	= "Автомобиль %s (ID %d) успешно удалён"
TEXT_VEHICLES_RESTORE_SUCCESS	= "Автомобиль %s (ID %d) успешно восстановлен"
TEXT_VEHICLES_COLOR_CHANGED		= "Цвет автомобиля %s (ID %d) успешно изменён на %s"
TEXT_VEHICLES_FUEL_CHANGED		= "Уровень топлива автомобиля %s (ID %d) успешно изменён на %d"
TEXT_VEHICLES_MODEL_CHANGED		= "Модель автомобиля %s (ID %d) успешно изменена на %s (%d)"
TEXT_VEHICLES_RESPAWN_CHANGED	= "Респавн автомобиля %s (ID %d) успешно изменён"
TEXT_VEHICLES_PLATE_CHANGED		= "Номер автомобиля %s (ID %d) успешно изменён на %s"
TEXT_VEHICLES_OWNER_CHANGED		= "Вы сделали %s (ID %d) владельцем автомобиля %s (ID %d)"
TEXT_VEHICLES_FACTION_CHANGED	= "Автомобиль %s (ID %d) теперь принадлежит фракции %s"
TEXT_VEHICLES_JOB_CHANGED		= "Автомобиль %s (ID %d) теперь принадлежит работе %s"
TEXT_VEHICLES_INVALID_COLOR		= "Некорректный цвет автомобиля"
TEXT_VEHICLES_INVALID_MODEL		= "Некорректная модель автомобиля"
TEXT_VEHICLES_VEHICLE_FIXED		= "Vehicle %s (ID %d) fixed"
TEXT_VEHICLES_TEMP_CAR_CREATED	= "Временный автомобиль %s создан, #FF0000ID: %d"
TEXT_VEHICLES_ACCESS_DENIED		= "Нет прав на удаление автомобилей из базы данных"
TEXT_VEHICLES_RESPAWNED			= "Vehicle %s (ID %d) respawned"
TEXT_VEHICLES_VARIANT_CHANGED	= "Дополнительные детали для автомобиля %s (ID %d) успешно изменены на %d, %d"		

TEXT_FACTIONS_INVALID_ID		= "Организации с таким ID не существует"
TEXT_FACTIONS_INVALID_TYPE		= "Такого типа организации не существует, доступные типы: %s"
TEXT_FACTIONS_INVALID_CLASS		= "Не правильный класс организации %q"
TEXT_FACTIONS_INVALID_RANK		= "Некорректный ранг для этой организации"
TEXT_FACTIONS_INVALID_RIGHTS	= "Некорректный уровень прав"
TEXT_FACTIONS_NAME_EXISTS		= "Организация с именем %q уже существует"
TEXT_FACTIONS_TAG_EXISTS		= "Организация с тегом %q уже существует"
TEXT_FACTIONS_CREATION_SUCCESS	= "Организация %s (%s) успешно создана (ID: %d)"
TEXT_FACTIONS_CREATION_FAILED	= "Ошибка при создании организации, обратитесь к системному администратору"

TEXT_JOBS_INVALID_ID			= "Работы с таким ID не существует"

TEXT_SHOPS_INVALID_ID			= "Магазина с таким ID не существует"
TEXT_SHOPS_CREATED				= "Магазин успешно создан, ID: %d"
TEXT_SHOPS_DELETED				= "Магазин ID %d успешно удалён"
TEXT_SHOPS_ITEM_ADDED			= "Предмет %q успешно добавлен в продажу в магазин ID %d"
TEXT_SHOPS_ITEM_ALREADY_ADDED	= "Этот предмет уже добавлен в продажу"
TEXT_SHOPS_ITEM_REMOVED			= "Предмет %q успешно удалён из продажи"
TEXT_SHOPS_ITEM_NOT_ADDED		= "Предмет %q отсутствует в продаже"

TEXT_ITEMS_INVALID_ID			= "Предмета с таким ID не существует"
TEXT_ITEMS_NOT_ENOUGH_SPACE		= "Недостаточно места"
TEXT_ITEMS_DOES_NOT_EXIST		= "Предмет который Вы пытаетесь передать - не существует"
TEXT_ITEMS_TRANSFER_FAILED		= "Невозможно передать предмет"

TEXT_EQUIPMENTS_INVALID_ID			= "Арсенала с таким ID не существует"
TEXT_EQUIPMENTS_CREATED				= "Арсенал для фракции %s успешно создан (ID %d)"
TEXT_EQUIPMENTS_DELETED				= "Арсенал ID %d успешно удалён"
TEXT_EQUIPMENTS_FACTION_CHANGED		= "Арсенал ID %d теперь принадлежит фракции %s (ID %d)"
TEXT_EQUIPMENTS_ITEM_ADDED			= "Предмет %q успешно добавлен в арсенал ID %d"
TEXT_EQUIPMENTS_ITEM_ALREADY_ADDED	= "Этот предмет уже добавлен в арсенал"
TEXT_EQUIPMENTS_ITEM_REMOVED		= "Предмет %q успешно удалён из арсенала"
TEXT_EQUIPMENTS_ITEM_NOT_ADDED		= "Предмет %q отсутствует в арсенале"