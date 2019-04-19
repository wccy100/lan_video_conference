#include "employee.h"

//Employee::Employee(std::string userID, std::string userPassword, bool state, std::string avatar, std::string company, std::string department, std::string group, std::string realName, std::string phone):m_userID(userID),m_userPassword(userPassword),m_state(state),m_avatar(avatar),m_company(company),m_department(department),m_group(group),m_realName(realName),m_phone(phone)
//{

//}

QString Employee::userID() const
{
    return m_userID;
}

void Employee::setUserID(const QString &userID)
{
    m_userID = userID;
}

QString Employee::userPassword() const
{
    return m_userPassword;
}

void Employee::setUserPassword(const QString &userPassword)
{
    m_userPassword = userPassword;
}

bool Employee::state() const
{
    return m_state;
}

void Employee::setState(bool state)
{
    m_state = state;
}

QString Employee::avatar() const
{
    return m_avatar;
}

void Employee::setAvatar(const QString &avatar)
{
    m_avatar = avatar;
}

QString Employee::company() const
{
    return m_company;
}

void Employee::setCompany(const QString &company)
{
    m_company = company;
}

QString Employee::department() const
{
    return m_department;
}

void Employee::setDepartment(const QString &department)
{
    m_department = department;
}

QString Employee::realName() const
{
    return m_realName;
}

void Employee::setRealName(const QString &realName)
{
    m_realName = realName;
}

QString Employee::phone() const
{
    return m_phone;
}

void Employee::setPhone(const QString &phone)
{
    m_phone = phone;
}

QString Employee::email() const
{
    return m_email;
}

void Employee::setEmail(const QString &email)
{
    m_email = email;
}

QString Employee::group() const
{
    return m_group;
}

void Employee::setGroup(const QString &group)
{
    m_group = group;
}

QQmlListProperty<Meeting> Employee::meetings()
{
    return QQmlListProperty<Meeting>(this,nullptr,Employee::appendMeeting,Employee::countMeeting,Employee::atMeeting,Employee::clearMeeting);
}

Meeting *Employee::getMeeting(int i)
{
    return _meetings[i];
}

int Employee::meetingCount()
{
    return _meetings.count();
}

void Employee::insertMeeting(Meeting *meeting)
{
    _meetings.append(meeting);
}

void Employee::setMeetings(const QList<Meeting *> &meetings)
{
    _meetings = meetings;
}

void Employee::appendMeeting(QQmlListProperty<Meeting> *meetings,Meeting *meeting){
    Employee *employee = qobject_cast<Employee *>(meetings->object);
    if(meeting) {
        meeting->setParent(employee);
        employee->_meetings.append(meeting);
    }
}

int Employee::countMeeting(QQmlListProperty<Meeting> *meetings)
{
    Employee *employee = qobject_cast<Employee *>(meetings->object);
    if(employee)
        return employee->_meetings.count();
    return 0;
}

Meeting *Employee::atMeeting(QQmlListProperty<Meeting> *meetings,int i)
{
    Employee *employee = qobject_cast<Employee *>(meetings->object);
    if(employee)
        return employee->_meetings.at(i);
    return nullptr;
}

void Employee::clearMeeting(QQmlListProperty<Meeting> *meetings)
{
    Employee *employee = qobject_cast<Employee *>(meetings->object);
    if(employee) {
        employee->_meetings.clear();
    }
}