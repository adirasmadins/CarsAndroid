#include "carview.h"

CarView::CarView(QObject *parent) : QObject(parent)
{
Database::setParameters("94.230.27.222", 3306, "sigmacars", "root", "Serwis4q@");

}

void CarView::setCarList()
{
    if(Database::connectToDatabase()) {
        m_carModel.setQuery("SELECT * FROM car;");

        if(m_carList.size() != 0) m_carList.clear();

        for(int i = 0; i < m_carModel.rowCount(); ++i) {
            m_carList.push_back(std::move(new CarBlock(m_carModel.index(i, 0).data().toInt(),
                                                       m_carModel.index(i, 1).data().toString(),
                                                       m_carModel.index(i, 2).data().toString(),
                                                       m_carModel.index(i, 3).data().toString(),
                                                       static_cast<bool>(m_carModel.index(i, 7).data().toInt()),
                                                       m_carModel.index(i, 8).data().toString(),
                                                       m_carModel.index(i, 6).data().toInt(),
                                                       i
                                                       )));

        }
        emit onCarListChanged(getCarList());
    }
    else
        qDebug() << "Cannot connect to database.";
}

int CarView::carListCount(QQmlListProperty<CarBlock>*list)
{
    CarView *carView = qobject_cast<CarView*>(list->object);
    if (carView)
        return carView->m_carList.count();
    return 0;
}

CarBlock* CarView::carListAt(QQmlListProperty<CarBlock> *list, int i)
{
    CarView *carView = qobject_cast<CarView*>(list->object);
    if (carView)
        return carView->m_carList.at(i);
    return 0;
}

QString CarView::generateCode()
{
    const int codeSize = 6;
    std::srand(time(NULL));

    std::string code("",codeSize);
    static const char alphanum[] =
        "0123456789"
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "abcdefghijklmnopqrstuvwxyz";

    for (int i = 0; i < codeSize; ++i)
        code[i] = alphanum[rand() % (sizeof(alphanum) - 1)];

    return QString::fromStdString(code);
}
