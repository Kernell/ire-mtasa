-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local Tests	=
{
	[ "Проверка знаний C#" ] =
	{
		{
			Text	= "Когда вызываются статические конструкторы классов в C#?";
			Answers	=
			{
				{ "Один раз при первом создании экземпляра класса или при первом обращении к статическим членам класса", true };
				{ "После каждого обращения к статическим полям, методам и свойствам" };
				{ "Строгий порядок вызова не определён" };
				{ "Статических конструкторов в C# нет" };
			};
			
		};
		{
			Text	= "Каким образом можно перехватить добавление и удаление делегата из события?";
			Answers	=
			{
				{ "Такая возможность не предусмотрена" };
				{ "Для этого существуют специальные ключевые слова add и remove", true };
				{ "Использовать ключевые слова get и set" };
				{ "Переопределить операторы + и – для делегата" };
			};
		};
		{
			Text	= "Что произойдёт при исполнении следующего кода? int i = 5; object o = i; long j = (long)o;";
			Answers	=
			{
				{ "Ошибок не произойдёт. Переменная j будет иметь значение 5", true };
				{ "Произойдёт ошибка времени компиляции" };
				{ "Средой исполнения будет вызвано исключение InvalidCastException" };
				{ "Значение переменной j предсказать нельзя" };
			};
		};
	};
};

class: CClientTest
{
	m_pClient	= NULL;
	m_pTest		= NULL;
	m_sTestName	= NULL;
	m_iQuestion	= 0;
	m_Answers	= NULL;
};

function CClientTest:CClientTest( pClient, sTestName )
	pClient.m_pTest		= self;
	
	self.m_pClient		= pClient;
	self.m_pTest		= Tests[ sTestName ];
	self.m_sTestName	= sTestName;
	
	if self.m_pClient and self.m_pClient:IsLoggedIn() and self.m_pTest then
		self.m_Answers	= {};
		
		self:NextQuestion();
	end
end

function CClientTest:Answer( iOption )
	self.m_Answers[ self.m_iQuestion ] = iOption;
	
	self:NextQuestion();
end

function CClientTest:NextQuestion()
	self.m_iQuestion	= self.m_iQuestion + 1;
	
	local pQuestion		= self.m_pTest[ self.m_iQuestion ];
	
	if pQuestion then
		local Answers = {};
		
		for i, Option in ipairs( pQuestion.Answers ) do
			table.insert( Answers, Option[ 1 ] );
		end
		
		self:Client().SetTestData( pQuestion.Text, Answers );
	else
		self:ShowResults();
	end
end

function CClientTest:ShowResults()
	local Results	= {};
	
	for iQuestion, pQuestion in ipairs( self.m_pTest ) do
		Results[ iQuestion ] =
		{
			Text	= pQuestion.Text;
			Options	= {};
		};
		
		for i, Option in ipairs( pQuestion.Answers ) do
			Results[ iQuestion ].Options[ i ] = { Option[ 1 ], Option[ 2 ] and i == self.m_Answers[ iQuestion ] };
		end
	end
	
	self.m_pClient:Client().TestShowResult( Result );
end

function CClientTest:_CClientTest()
	self.m_pClient.m_pTest	= NULL;
	
	self.m_pClient			= NULL;
	self.m_pTest			= NULL;
	self.m_sTestName		= NULL;
	self.m_iQuestion		= 0;
	self.m_Answers			= NULL;
end
